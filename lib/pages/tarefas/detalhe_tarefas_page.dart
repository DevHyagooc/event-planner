import 'package:flutter/material.dart';

import '../../models/event_task.dart';
import '../../models/evento.dart';
import '../../services/firestore_service.dart';
import '../editar_evento.dart';
import 'form_tarefa_page.dart';
import 'tarefas_models.dart';
import 'tarefas_shared.dart';

class DetalheTarefasPage extends StatefulWidget {
  const DetalheTarefasPage({super.key, required this.event});

  final Evento event;

  @override
  State<DetalheTarefasPage> createState() => _DetalheTarefasPageState();
}

class _DetalheTarefasPageState extends State<DetalheTarefasPage> {
  final FirestoreService _firestoreService = FirestoreService();
  TaskFilter _selectedFilter = TaskFilter.all;

  List<EventTask> _visibleTasks(List<EventTask> tasks) {
    return tasks.where(_selectedFilter.matches).toList();
  }

  Future<void> _openForm({EventTask? task}) async {
    final result = await Navigator.push<EventTask>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FormTarefaPage(eventId: widget.event.id, initialTask: task),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaskPalette.background,
      body: SafeArea(
        child: StreamBuilder<List<EventTask>>(
          stream: _firestoreService.getTasks(widget.event.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: TaskPalette.primary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar tarefas: ${snapshot.error}'),
              );
            }

            final tasks = snapshot.data ?? [];
            final visibleTasks = _visibleTasks(tasks);
            final completedCount = tasks
                .where((task) => task.isCompleted)
                .length;
            final pendingCount = tasks.length - completedCount;
            final progress = tasks.isEmpty
                ? 0.0
                : completedCount / tasks.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: TaskPalette.text,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.event.titulo,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: TaskPalette.text,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditarEvento(evento: widget.event),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: TaskPalette.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: TaskPalette.border),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: TaskPalette.muted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        TaskDateFormatter.eventDate(widget.event.data),
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: TaskPalette.muted,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: TaskPalette.muted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.event.local,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: TaskPalette.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: TaskPalette.primaryLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      TaskStatusFormatter.eventStatus(widget.event.status),
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: TaskPalette.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: TaskPalette.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.event.descricao.isEmpty
                        ? 'Sem descrição.'
                        : widget.event.descricao,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: TaskPalette.text,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TaskSummaryCard(
                    completedCount: completedCount,
                    pendingCount: pendingCount,
                    progress: progress,
                  ),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 330;
                      final addButton = TaskPrimaryButton(
                        label: 'Adicionar',
                        icon: Icons.add,
                        fullWidth: false,
                        onPressed: () => _openForm(),
                      );

                      const title = Text(
                        'Tarefas',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: TaskPalette.text,
                        ),
                      );

                      if (isCompact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title,
                            const SizedBox(height: 12),
                            SizedBox(width: double.infinity, child: addButton),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          const Expanded(child: title),
                          const SizedBox(width: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 120,
                              maxWidth: 132,
                            ),
                            child: addButton,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      TaskFilterChip(
                        label: 'Todas',
                        isSelected: _selectedFilter == TaskFilter.all,
                        onTap: () =>
                            setState(() => _selectedFilter = TaskFilter.all),
                      ),
                      const SizedBox(width: 10),
                      TaskFilterChip(
                        label: 'Pendentes',
                        isSelected: _selectedFilter == TaskFilter.pending,
                        onTap: () => setState(
                          () => _selectedFilter = TaskFilter.pending,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TaskFilterChip(
                        label: 'Concluídas',
                        isSelected: _selectedFilter == TaskFilter.completed,
                        onTap: () => setState(
                          () => _selectedFilter = TaskFilter.completed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (visibleTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: SizedBox(
                        height: 180,
                        child: Center(child: TaskEmptyStateContent()),
                      ),
                    )
                  else
                    ...visibleTasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventTaskCard(
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onEdit: () => _openForm(task: task),
                          onDelete: () => _deleteTask(task),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
