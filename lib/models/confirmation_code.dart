import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmationCode {
  final String id;
  final String userId;
  final String codeHash;
  final DateTime expiresAt;
  final DateTime? consumedAt;
  final DateTime createdAt;

  ConfirmationCode({
    required this.id,
    required this.userId,
    required this.codeHash,
    required this.expiresAt,
    this.consumedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'codeHash': codeHash,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'consumedAt': consumedAt != null ? Timestamp.fromDate(consumedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ConfirmationCode.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ConfirmationCode(
      id: doc.id,
      userId: data['userId'] ?? '',
      codeHash: data['codeHash'] ?? '',
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      consumedAt: data['consumedAt'] != null ? (data['consumedAt'] as Timestamp).toDate() : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
