import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String id;
  final String name;
  final String description;
  final String managerId;
  final String managerName;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.managerId,
    required this.managerName,
  });

  factory Team.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Team(
      id: doc.id,
      name: data?['name'] as String? ?? '',
      description: data?['description'] as String? ?? '',
      managerId: data?['managerId'] as String? ?? '',
      managerName: data?['managerName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'managerId': managerId,
      'managerName': managerName,
    };
  }
}
