import 'package:flutter/material.dart';

import '../../models/event_task.dart';
import '../../models/evento.dart';

class TaskPalette {
  static const background = Color(0xFFF5F3F1);
  static const surface = Colors.white;
  static const border = Color(0xFFE6E1DC);
  static const muted = Color(0xFF9A948F);
  static const text = Color(0xFF111111);
  static const primary = Color(0xFFE76E50);
  static const primaryLight = Color(0xFFFAE2DC);
  static const chip = Color(0xFFF1EEEA);
  static const completed = Color(0xFFEDE8E4);
}

class TaskDateFormatter {
  static const List<String> _months = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  static String shortMonth(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]}';
  }

  static String fullDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String eventDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}

class TaskStatusFormatter {
  static String eventStatus(EventoStatus status) {
    switch (status) {
      case EventoStatus.planejando:
        return 'Planejando';
      case EventoStatus.concluido:
        return 'Concluído';
      case EventoStatus.cancelado:
        return 'Cancelado';
    }
  }
}

Future<bool> showTaskDeleteConfirmation(BuildContext context) {
  return showDeleteConfirmation(
    context,
    title: 'Excluir tarefa?',
    message: 'Isso removerá a tarefa permanentemente.',
  );
}

Future<bool> showEventDeleteConfirmation(BuildContext context) {
  return showDeleteConfirmation(
    context,
    title: 'Excluir evento?',
    message: 'Isso removerá o evento e suas tarefas permanentemente.',
  );
}

Future<bool> showDeleteConfirmation(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.12),
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: TaskPalette.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: TaskPalette.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: TaskPalette.muted,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TaskPalette.muted,
                          side: const BorderSide(color: TaskPalette.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TaskPalette.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}

class TaskFilterChip extends StatelessWidget {
  const TaskFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TaskPalette.primary : TaskPalette.chip,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : TaskPalette.text,
          ),
        ),
      ),
    );
  }
}

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key,
    required this.completedCount,
    required this.pendingCount,
    required this.progress,
  });

  final int completedCount;
  final int pendingCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final completedLabel = completedCount == 1 ? 'concluída' : 'concluídas';
    final pendingLabel = pendingCount == 1 ? 'pendente' : 'pendentes';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TaskPalette.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TaskPalette.text,
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: TaskPalette.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE8E1DC),
              valueColor: const AlwaysStoppedAnimation(TaskPalette.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completedCount $completedLabel  $pendingCount $pendingLabel',
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: TaskPalette.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class EventTaskCard extends StatelessWidget {
  const EventTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  final EventTask task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = task.isCompleted
        ? TaskPalette.completed
        : TaskPalette.surface;
    final titleColor = task.isCompleted ? TaskPalette.muted : TaskPalette.text;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? TaskPalette.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: TaskPalette.primary),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 12,
                        color: TaskPalette.muted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          task.responsible,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: TaskPalette.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: TaskPalette.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TaskDateFormatter.shortMonth(task.dueDate),
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: TaskPalette.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: TaskPalette.text,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskEmptyState extends StatelessWidget {
  const TaskEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
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
        Icon(Icons.task_alt_outlined, size: 76, color: TaskPalette.primary),
        SizedBox(height: 22),
        Text(
          'Nenhuma tarefa encontrada.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: TaskPalette.muted,
          ),
        ),
      ],
    );
  }
}

class TaskBottomNavigation extends StatelessWidget {
  const TaskBottomNavigation({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    Widget item({
      required IconData icon,
      required String label,
      required bool selected,
    }) {
      final color = selected ? TaskPalette.primary : TaskPalette.muted;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 88,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            top: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              color: TaskPalette.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  item(
                    icon: Icons.home_outlined,
                    label: 'Início',
                    selected: false,
                  ),
                  item(
                    icon: Icons.calendar_today_outlined,
                    label: 'Agenda',
                    selected: false,
                  ),
                  const SizedBox(width: 54),
                  item(
                    icon: Icons.fact_check_outlined,
                    label: 'Tarefas',
                    selected: true,
                  ),
                  item(
                    icon: Icons.person_outline,
                    label: 'Perfil',
                    selected: false,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: TaskPalette.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskPrimaryButton extends StatelessWidget {
  const TaskPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TaskPalette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
