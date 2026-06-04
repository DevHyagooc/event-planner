import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evento.dart';
import '../models/app_user.dart';
import '../models/event_task.dart';
import 'firebase_constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Usuários ---
  CollectionReference get _usuariosRef => _db.collection(FirebaseConstants.usuariosCollection);

  Future<void> saveUser(AppUser user) {
    return _usuariosRef.doc(user.id.isEmpty ? null : user.id).set(
          user.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<AppUser?> getUser(String id) async {
    final doc = await _usuariosRef.doc(id).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  // --- Eventos ---
  CollectionReference get _eventosRef => _db.collection(FirebaseConstants.eventosCollection);

  Future<void> saveEvento(Evento evento) {
    return _eventosRef.doc(evento.id.isEmpty ? null : evento.id).set(
          evento.toFirestore(),
          SetOptions(merge: true),
        );
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

  Future<void> deleteEvento(String id) {
    return _eventosRef.doc(id).delete();
  }

  // --- Tarefas ---
  CollectionReference get _tarefasRef => _db.collection(FirebaseConstants.tarefasCollection);

  Future<void> saveTask(EventTask task) {
    return _tarefasRef.doc(task.id.isEmpty ? null : task.id).set(
          task.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Stream<List<EventTask>> getTasks(String eventId) {
    return _tarefasRef
        .where('eventId', isEqualTo: eventId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => EventTask.fromFirestore(doc)).toList();
    });
  }

  Future<void> deleteTask(String id) {
    return _tarefasRef.doc(id).delete();
  }
}
