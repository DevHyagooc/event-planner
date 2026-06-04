import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String firebaseAuthUid;
  final String name;
  final String cpf;
  final String email;
  final bool emailVerified;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.firebaseAuthUid,
    required this.name,
    required this.cpf,
    required this.email,
    this.emailVerified = false,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'firebaseAuthUid': firebaseAuthUid,
      'name': name,
      'cpf': cpf,
      'email': email,
      'emailVerified': emailVerified,
      'avatarUrl': avatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      firebaseAuthUid: data['firebaseAuthUid'] ?? '',
      name: data['name'] ?? '',
      cpf: data['cpf'] ?? '',
      email: data['email'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      avatarUrl: data['avatarUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
