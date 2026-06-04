import 'package:cloud_firestore/cloud_firestore.dart';

class EventTask {
  final String id;
  final String eventId;
  final String title;
  final String responsible;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventTask({
    required this.id,
    required this.eventId,
    required this.title,
    required this.responsible,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'title': title,
      'responsible': responsible,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory EventTask.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventTask(
      id: doc.id,
      eventId: data['eventId'] ?? '',
      title: data['title'] ?? '',
      responsible: data['responsible'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null ? (data['completedAt'] as Timestamp).toDate() : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  EventTask copyWith({
    String? id,
    String? eventId,
    String? title,
    String? responsible,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventTask(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      responsible: responsible ?? this.responsible,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
