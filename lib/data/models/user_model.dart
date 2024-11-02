import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime? lastSignInAt;

  User({
    required this.id,
    required this.phoneNumber,
    required this.createdAt,
    this.lastSignInAt,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      phoneNumber: data['phoneNumber'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastSignInAt: data['lastSignInAt'] != null ? (data['lastSignInAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSignInAt': lastSignInAt != null ? Timestamp.fromDate(lastSignInAt!) : null,
    };
  }
}
