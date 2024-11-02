import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String position;
  final String teamId;
  final String email;
  final String phoneNumber;
  final DateTime hireDate;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.teamId,
    required this.email,
    required this.phoneNumber,
    required this.hireDate,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      name: data['name'] as String,
      position: data['position'] as String,
      teamId: data['teamId'] as String,
      email: data['email'] as String,
      phoneNumber: data['phoneNumber'] as String,
      hireDate: (data['hireDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'teamId': teamId,
      'email': email,
      'phoneNumber': phoneNumber,
      'hireDate': Timestamp.fromDate(hireDate),
    };
  }
}
