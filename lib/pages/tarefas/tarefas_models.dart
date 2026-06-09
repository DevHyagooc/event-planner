import '../../models/event_task.dart';

enum TaskFilter { all, pending, completed }

extension TaskFilterMatcher on TaskFilter {
  bool matches(EventTask task) {
    switch (this) {
      case TaskFilter.pending:
        return !task.isCompleted;
      case TaskFilter.completed:
        return task.isCompleted;
      case TaskFilter.all:
        return true;
    }
  }
}
