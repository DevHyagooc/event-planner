import 'package:flutter/material.dart';

enum EventoStatus { planejando, concluido, cancelado }

class Evento {
  final String id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final String local;
  final EventoStatus status;
  final int totalTarefas;
  final int tarefasConcluidas;

  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.local,
    this.status = EventoStatus.planejando,
    this.totalTarefas = 0,
    this.tarefasConcluidas = 0,
  });

  double get progresso => totalTarefas == 0 ? 0 : tarefasConcluidas / totalTarefas;
}
