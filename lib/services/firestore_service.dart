import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evento.dart';
import '../models/app_user.dart';
import '../models/event_task.dart';
import '../models/estatisticas_perfil.dart';
import 'firebase_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Usuários ---
  CollectionReference get _usuariosRef =>
      _db.collection(FirebaseConstants.usuariosCollection);

  Future<void> saveUser(AppUser user) {
    return _usuariosRef
        .doc(user.id)
        .set(user.toFirestore(), SetOptions(merge: true));
  }

  Future<AppUser?> getUser(String id) async {
    final doc = await _usuariosRef.doc(id).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  Stream<AppUser?> streamUser(String id) {
    return _usuariosRef.doc(id).snapshots().map(
          (doc) => doc.exists ? AppUser.fromFirestore(doc) : null,
        );
  }

    Future<bool> cpfExiste(String cpf) async {
    final result = await _usuariosRef
        .where('cpf', isEqualTo: cpf)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<bool> emailExiste(String email) async {
    final result = await _usuariosRef
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  // --- Eventos ---
  CollectionReference get _eventosRef =>
      _db.collection(FirebaseConstants.eventosCollection);

  Future<void> saveEvento(Evento evento) {
    return _eventosRef
        .doc(evento.id.isEmpty ? null : evento.id)
        .set(evento.toFirestore(), SetOptions(merge: true));
  }

  Stream<List<Evento>> getEventos(String userId) {
    return _eventosRef
        .where('userId', isEqualTo: userId)
        .orderBy('data', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Evento.fromFirestore(doc)).toList();
        });
  }

  Future<List<Evento>> getEventosOnce(String userId) async {
    final snapshot = await _eventosRef
        .where('userId', isEqualTo: userId)
        .orderBy('data', descending: false)
        .get();

    return snapshot.docs.map((doc) => Evento.fromFirestore(doc)).toList();
  }

  Future<void> deleteEvento(String id) {
    return _eventosRef.doc(id).delete();
  }

  Stream<EstatisticasPerfil> streamEstatisticas(String userId) {
    return _eventosRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final eventos = snapshot.docs.map(Evento.fromFirestore).toList();
      return EstatisticasPerfil(
        totalEventos: eventos.length,
        eventosConcluidos:
            eventos.where((e) => e.status == EventoStatus.concluido).length,
        totalTarefas: eventos.fold(0, (soma, e) => soma + e.totalTarefas),
        tarefasFinalizadas:
            eventos.fold(0, (soma, e) => soma + e.tarefasConcluidas),
      );
    });
  }

  // --- Tarefas ---
  CollectionReference get _tarefasRef =>
      _db.collection(FirebaseConstants.tarefasCollection);

  Future<void> saveTask(EventTask task) async {
    if (task.eventId.trim().isEmpty) {
      throw ArgumentError('A tarefa precisa pertencer a um evento.');
    }

    final taskRef = task.id.isEmpty
        ? _tarefasRef.doc()
        : _tarefasRef.doc(task.id);

    await taskRef.set(task.toFirestore(), SetOptions(merge: true));
    await _updateEventoTaskCounters(task.eventId);
  }

  Stream<List<EventTask>> getTasks(String eventId) {
    return _tarefasRef.where('eventId', isEqualTo: eventId).snapshots().map((
      snapshot,
    ) {
      final tasks = snapshot.docs
          .map((doc) => EventTask.fromFirestore(doc))
          .toList();
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return tasks;
    });
  }

  Stream<List<EventTask>> getTasksForEvents(List<String> eventIds) {
    if (eventIds.isEmpty) {
      return Stream.value([]);
    }

    if (eventIds.length <= 30) {
      return _tarefasRef.where('eventId', whereIn: eventIds).snapshots().map((
        snapshot,
      ) {
        final tasks = snapshot.docs
            .map((doc) => EventTask.fromFirestore(doc))
            .toList();
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        return tasks;
      });
    }

    return _tarefasRef.snapshots().map((snapshot) {
      final allowedEventIds = eventIds.toSet();
      final tasks = snapshot.docs
          .map((doc) => EventTask.fromFirestore(doc))
          .where((task) => allowedEventIds.contains(task.eventId))
          .toList();
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return tasks;
    });
  }

  Future<void> deleteTask(String id) async {
    final taskDoc = await _tarefasRef.doc(id).get();
    if (!taskDoc.exists) {
      return;
    }

    final data = taskDoc.data() as Map<String, dynamic>;
    final eventId = data['eventId'] as String? ?? '';

    await _tarefasRef.doc(id).delete();
    if (eventId.isNotEmpty) {
      await _updateEventoTaskCounters(eventId);
    }
  }

  Future<void> _updateEventoTaskCounters(String eventId) async {
    if (eventId.isEmpty) {
      return;
    }

    final tasksSnapshot = await _tarefasRef
        .where('eventId', isEqualTo: eventId)
        .get();
    final totalTarefas = tasksSnapshot.docs.length;
    final tarefasConcluidas = tasksSnapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['isCompleted'] == true;
    }).length;

    await _eventosRef.doc(eventId).update({
      'totalTarefas': totalTarefas,
      'tarefasConcluidas': tarefasConcluidas,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
