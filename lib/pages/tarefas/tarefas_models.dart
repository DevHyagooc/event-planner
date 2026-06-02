enum TaskFilter {
  all,
  pending,
  completed,
}

enum EventTaskStatus {
  planning('Planejando');

  const EventTaskStatus(this.label);

  final String label;
}

class EventTask {
  const EventTask({
    required this.id,
    required this.title,
    required this.responsible,
    required this.dueDate,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String responsible;
  final DateTime dueDate;
  final bool isCompleted;

  EventTask copyWith({
    String? id,
    String? title,
    String? responsible,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return EventTask(
      id: id ?? this.id,
      title: title ?? this.title,
      responsible: responsible ?? this.responsible,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class EventTaskGroup {
  const EventTaskGroup({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    required this.tasks,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final EventTaskStatus status;
  final List<EventTask> tasks;

  int get completedCount => tasks.where((task) => task.isCompleted).length;

  int get pendingCount => tasks.where((task) => !task.isCompleted).length;

  double get progress => tasks.isEmpty ? 0 : completedCount / tasks.length;

  EventTaskGroup copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    EventTaskStatus? status,
    List<EventTask>? tasks,
  }) {
    return EventTaskGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
    );
  }

  List<EventTask> tasksFor(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return List<EventTask>.from(tasks);
    }
  }
}
