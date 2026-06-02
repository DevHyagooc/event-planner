import 'package:flutter/material.dart';

import 'form_tarefa_page.dart';
import 'tarefas_models.dart';
import 'tarefas_shared.dart';

class DetalheTarefasPage extends StatefulWidget {
  const DetalheTarefasPage({
    super.key,
    required this.event,
  });

  final EventTaskGroup event;

  @override
  State<DetalheTarefasPage> createState() => _DetalheTarefasPageState();
}

class _DetalheTarefasPageState extends State<DetalheTarefasPage> {
  late EventTaskGroup _event;
  TaskFilter _selectedFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  Future<bool> _handleBack() async {
    Navigator.pop(context, _event);
    return false;
  }

  List<EventTask> get _visibleTasks => _event.tasksFor(_selectedFilter);

  Future<void> _openForm({EventTask? task}) async {
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
      if (task == null) {
        _event = _event.copyWith(tasks: [..._event.tasks, result]);
        return;
      }

      _event = _event.copyWith(
        tasks: _event.tasks
            .map((item) => item.id == task.id ? result : item)
            .toList(),
      );
    });
  }

  void _toggleTask(EventTask task) {
    setState(() {
      _event = _event.copyWith(
        tasks: _event.tasks
            .map(
              (item) => item.id == task.id
                  ? item.copyWith(isCompleted: !item.isCompleted)
                  : item,
            )
            .toList(),
      );
    });
  }

  void _deleteTask(EventTask task) {
    setState(() {
      _event = _event.copyWith(
        tasks: _event.tasks.where((item) => item.id != task.id).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: TaskPalette.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _handleBack(),
                      icon: const Icon(Icons.arrow_back, color: TaskPalette.text),
                    ),
                    Expanded(
                      child: Text(
                        _event.title,
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: TaskPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: TaskPalette.border),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: TaskPalette.muted),
                    const SizedBox(width: 6),
                    Text(
                      TaskDateFormatter.eventDate(_event.date),
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: TaskPalette.muted,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.location_on_outlined, size: 14, color: TaskPalette.muted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _event.location,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TaskPalette.primaryLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _event.status.label,
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
                  _event.description,
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
                  completedCount: _event.completedCount,
                  pendingCount: _event.pendingCount,
                  progress: _event.progress,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tarefas',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: TaskPalette.text,
                      ),
                    ),
                    SizedBox(
                      width: 132,
                      child: TaskPrimaryButton(
                        label: '+  Adicionar',
                        onPressed: () => _openForm(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 18),
                if (_visibleTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                      height: 180,
                      child: Center(child: TaskEmptyStateContent()),
                    ),
                  )
                else
                  ..._visibleTasks.map(
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
          ),
        ),
      ),
    );
  }
}

class TaskEmptyStateContent extends StatelessWidget {
  const TaskEmptyStateContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.task_alt_outlined, size: 44, color: TaskPalette.primary),
        SizedBox(height: 10),
        Text(
          'Nenhuma tarefa encontrada.',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: TaskPalette.muted,
          ),
        ),
      ],
    );
  }
}
