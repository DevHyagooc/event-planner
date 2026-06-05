import 'package:cloud_firestore/cloud_firestore.dart';

enum EventoStatus { planejando, concluido, cancelado }

class Evento {
  final String id;
  final String userId;
  final String titulo;
  final String descricao;
  final String local;
  final DateTime data;
  final String? hora;
  final EventoStatus status;
  final int totalTarefas;
  final int tarefasConcluidas;
  final DateTime createdAt;
  final DateTime updatedAt;

  Evento({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.descricao,
    required this.local,
    required this.data,
    this.hora,
    this.status = EventoStatus.planejando,
    this.totalTarefas = 0,
    this.tarefasConcluidas = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progresso => totalTarefas == 0 ? 0 : tarefasConcluidas / totalTarefas;

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'titulo': titulo,
      'descricao': descricao,
      'local': local,
      'data': Timestamp.fromDate(data),
      'hora': hora,
      'status': status.name,
      'totalTarefas': totalTarefas,
      'tarefasConcluidas': tarefasConcluidas,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Evento.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Evento(
      id: doc.id,
      userId: data['userId'] ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      local: data['local'] ?? '',
      data: (data['data'] as Timestamp).toDate(),
      hora: data['hora'],
      status: EventoStatus.values.byName(data['status'] ?? 'planejando'),
      totalTarefas: data['totalTarefas'] ?? 0,
      tarefasConcluidas: data['tarefasConcluidas'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
