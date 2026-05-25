import 'package:flutter/material.dart';

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
  TaskFilter _selectedFilter = TaskFilter.all;
  late List<EventTaskGroup> _events;

  @override
  void initState() {
    super.initState();
    _events = _buildInitialEvents();
  }

  List<EventTaskGroup> _buildInitialEvents() {
    return [
      EventTaskGroup(
        id: 'event-1',
        title: 'Aniversário de João',
        description: 'Organização das entregas e definições principais do evento.',
        location: 'Salão de festas',
        date: DateTime(2026, 3, 28),
        status: EventTaskStatus.planning,
        tasks: [
          EventTask(
            id: 'task-1',
            title: 'Tarefa 1',
            responsible: 'Carlos',
            dueDate: DateTime(2026, 3, 30),
          ),
          EventTask(
            id: 'task-2',
            title: 'Tarefa 2',
            responsible: 'Carlos',
            dueDate: DateTime(2026, 3, 30),
          ),
        ],
      ),
      EventTaskGroup(
        id: 'event-2',
        title: 'Aniversário de Carla',
        description: 'Checklist final das pendências com equipe e fornecedores.',
        location: 'Espaço de eventos',
        date: DateTime(2026, 4, 2),
        status: EventTaskStatus.planning,
        tasks: [
          EventTask(
            id: 'task-3',
            title: 'Tarefa 2',
            responsible: 'Carlos',
            dueDate: DateTime(2026, 3, 30),
            isCompleted: true,
          ),
        ],
      ),
    ];
  }

  List<EventTaskGroup> get _visibleEvents {
    return _events
        .map(
          (event) => event.copyWith(tasks: event.tasksFor(_selectedFilter)),
        )
        .where((event) => event.tasks.isNotEmpty)
        .toList();
  }

  Future<void> _openEvent(EventTaskGroup event) async {
    final result = await Navigator.push<EventTaskGroup>(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheTarefasPage(event: event),
      ),
    );

    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _events = _events
          .map((item) => item.id == result.id ? result : item)
          .toList();
    });
  }

  Future<void> _openTaskFormForEvent(EventTaskGroup event, {EventTask? task}) async {
    final result = await Navigator.push<EventTask>(
      context,
      MaterialPageRoute(
        builder: (_) => FormTarefaPage(initialTask: task),
      ),
    );

    if (result == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _events = _events.map((currentEvent) {
        if (currentEvent.id != event.id) {
          return currentEvent;
        }

        if (task == null) {
          return currentEvent.copyWith(tasks: [...currentEvent.tasks, result]);
        }

        final updatedTasks = currentEvent.tasks
            .map((item) => item.id == task.id ? result : item)
            .toList();

        return currentEvent.copyWith(tasks: updatedTasks);
      }).toList();
    });
  }

  void _toggleTask(EventTaskGroup event, EventTask task) {
    setState(() {
      _events = _events.map((currentEvent) {
        if (currentEvent.id != event.id) {
          return currentEvent;
        }

        final updatedTasks = currentEvent.tasks
            .map(
              (item) => item.id == task.id
                  ? item.copyWith(isCompleted: !item.isCompleted)
                  : item,
            )
            .toList();

        return currentEvent.copyWith(tasks: updatedTasks);
      }).toList();
    });
  }

  void _deleteTask(EventTaskGroup event, EventTask task) {
    setState(() {
      _events = _events.map((currentEvent) {
        if (currentEvent.id != event.id) {
          return currentEvent;
        }

        return currentEvent.copyWith(
          tasks: currentEvent.tasks.where((item) => item.id != task.id).toList(),
        );
      }).toList();
    });
  }

  Future<void> _handleAddFromBottomNavigation() async {
    if (_events.isEmpty) {
      return;
    }

    if (_events.length == 1) {
      await _openTaskFormForEvent(_events.first);
      return;
    }

    final selectedEvent = await showModalBottomSheet<EventTaskGroup>(
      context: context,
      backgroundColor: TaskPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Adicionar tarefa em',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TaskPalette.text,
                ),
              ),
              const SizedBox(height: 16),
              ..._events.map(
                (event) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    event.title,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    TaskDateFormatter.eventDate(event.date),
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 12,
                      color: TaskPalette.muted,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Navigator.pop(context, event),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedEvent == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    await _openTaskFormForEvent(selectedEvent);
  }

  @override
  Widget build(BuildContext context) {
    final visibleEvents = _visibleEvents;

    return Scaffold(
      backgroundColor: TaskPalette.background,
      body: SafeArea(
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
                    isSelected: _selectedFilter == TaskFilter.all,
                    onTap: () => setState(() => _selectedFilter = TaskFilter.all),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: 'Pendentes',
                    isSelected: _selectedFilter == TaskFilter.pending,
                    onTap: () => setState(() => _selectedFilter = TaskFilter.pending),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: 'Concluídas',
                    isSelected: _selectedFilter == TaskFilter.completed,
                    onTap: () => setState(() => _selectedFilter = TaskFilter.completed),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (visibleEvents.isEmpty)
                const TaskEmptyState()
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: visibleEvents.length,
                    itemBuilder: (context, index) {
                      final event = visibleEvents[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _openEvent(
                                _events.firstWhere((item) => item.id == event.id),
                              ),
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: TaskPalette.muted,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...event.tasks.map(
                              (task) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: EventTaskCard(
                                  task: task,
                                  onTap: () => _openEvent(
                                    _events.firstWhere((item) => item.id == event.id),
                                  ),
                                  onToggle: () => _toggleTask(
                                    _events.firstWhere((item) => item.id == event.id),
                                    task,
                                  ),
                                  onEdit: () => _openTaskFormForEvent(
                                    _events.firstWhere((item) => item.id == event.id),
                                    task: task,
                                  ),
                                  onDelete: () => _deleteTask(
                                    _events.firstWhere((item) => item.id == event.id),
                                    task,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TaskBottomNavigation(
        onAddTap: _handleAddFromBottomNavigation,
      ),
    );
  }
}
