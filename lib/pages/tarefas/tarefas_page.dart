import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/event_task.dart';
import '../../models/evento.dart';
import '../../services/firestore_service.dart';
import 'detalhe_tarefas_page.dart';
import 'form_tarefa_page.dart';
import 'tarefas_models.dart';
import 'tarefas_shared.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final FirestoreService _firestoreService = FirestoreService();
  TaskFilter _selectedFilter = TaskFilter.all;

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'user-teste-123';

  Future<void> _openEvent(Evento event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalheTarefasPage(event: event)),
    );
  }

  Future<void> _openTaskFormForEvent(Evento event, {EventTask? task}) async {
    final result = await Navigator.push<EventTask>(
      context,
      MaterialPageRoute(
        builder: (_) => FormTarefaPage(eventId: event.id, initialTask: task),
      ),
    );

    if (result == null) {
      return;
    }

    try {
      await _firestoreService.saveTask(result);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar tarefa: $e')));
    }
  }

  Future<void> _toggleTask(EventTask task) async {
    final now = DateTime.now();
    final isCompleted = !task.isCompleted;

    final updatedTask = EventTask(
      id: task.id,
      eventId: task.eventId,
      title: task.title,
      responsible: task.responsible,
      dueDate: task.dueDate,
      isCompleted: isCompleted,
      completedAt: isCompleted ? now : null,
      createdAt: task.createdAt,
      updatedAt: now,
    );

    try {
      await _firestoreService.saveTask(updatedTask);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar tarefa: $e')));
    }
  }

  Future<void> _deleteTask(EventTask task) async {
    final shouldDelete = await showTaskDeleteConfirmation(context);
    if (!shouldDelete) {
      return;
    }

    try {
      await _firestoreService.deleteTask(task.id);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir tarefa: $e')));
    }
  }

  List<EventTask> _tasksForEvent(List<EventTask> tasks, String eventId) {
    return tasks
        .where(
          (task) => task.eventId == eventId && _selectedFilter.matches(task),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId.isEmpty) {
      return const Center(child: Text('Usuário não autenticado.'));
    }

    return StreamBuilder<List<Evento>>(
      stream: _firestoreService.getEventos(_currentUserId),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: TaskPalette.primary),
          );
        }

        if (eventSnapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar eventos: ${eventSnapshot.error}'),
          );
        }

        final events = eventSnapshot.data ?? [];

        return _TaskListContent(
          events: events,
          selectedFilter: _selectedFilter,
          onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
          taskStream: _firestoreService.getTasksForEvents(
            events.map((event) => event.id).toList(),
          ),
          tasksForEvent: _tasksForEvent,
          onOpenEvent: _openEvent,
          onOpenTaskFormForEvent: _openTaskFormForEvent,
          onToggleTask: _toggleTask,
          onDeleteTask: _deleteTask,
        );
      },
    );
  }
}

class _TaskListContent extends StatelessWidget {
  const _TaskListContent({
    required this.events,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.taskStream,
    required this.tasksForEvent,
    required this.onOpenEvent,
    required this.onOpenTaskFormForEvent,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  final List<Evento> events;
  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onFilterChanged;
  final Stream<List<EventTask>> taskStream;
  final List<EventTask> Function(List<EventTask> tasks, String eventId)
  tasksForEvent;
  final ValueChanged<Evento> onOpenEvent;
  final Future<void> Function(Evento event, {EventTask? task})
  onOpenTaskFormForEvent;
  final ValueChanged<EventTask> onToggleTask;
  final ValueChanged<EventTask> onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tarefas',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: TaskPalette.text,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TaskFilterChip(
                  label: 'Todas',
                  isSelected: selectedFilter == TaskFilter.all,
                  onTap: () => onFilterChanged(TaskFilter.all),
                ),
                const SizedBox(width: 10),
                TaskFilterChip(
                  label: 'Pendentes',
                  isSelected: selectedFilter == TaskFilter.pending,
                  onTap: () => onFilterChanged(TaskFilter.pending),
                ),
                const SizedBox(width: 10),
                TaskFilterChip(
                  label: 'Concluídas',
                  isSelected: selectedFilter == TaskFilter.completed,
                  onTap: () => onFilterChanged(TaskFilter.completed),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<EventTask>>(
                stream: taskStream,
                builder: (context, taskSnapshot) {
                  if (taskSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: TaskPalette.primary,
                      ),
                    );
                  }

                  if (taskSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar tarefas: ${taskSnapshot.error}',
                      ),
                    );
                  }

                  final tasks = taskSnapshot.data ?? [];
                  final visibleEvents = events
                      .map(
                        (event) => (
                          event: event,
                          tasks: tasksForEvent(tasks, event.id),
                        ),
                      )
                      .where((group) => group.tasks.isNotEmpty)
                      .toList();

                  if (visibleEvents.isEmpty) {
                    return const Center(child: TaskEmptyStateContent());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: visibleEvents.length,
                    itemBuilder: (context, index) {
                      final group = visibleEvents[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => onOpenEvent(group.event),
                              child: Text(
                                group.event.titulo,
                                style: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: TaskPalette.muted,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...group.tasks.map(
                              (task) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: EventTaskCard(
                                  task: task,
                                  onTap: () => onOpenEvent(group.event),
                                  onToggle: () => onToggleTask(task),
                                  onEdit: () => onOpenTaskFormForEvent(
                                    group.event,
                                    task: task,
                                  ),
                                  onDelete: () => onDeleteTask(task),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
