import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  final String id;
  final String employeeId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String shiftPeriodId;

  Shift({
    required this.id,
    required this.employeeId,
    required this.startDateTime,
    required this.endDateTime,
    required this.shiftPeriodId,
  });

  factory Shift.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Shift(
      id: doc.id,
      employeeId: data['employeeId'] as String? ?? '',
      startDateTime: (data['startDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDateTime: (data['endDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      shiftPeriodId: data['shiftPeriodId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'shiftPeriodId': shiftPeriodId,
    };
  }

  int get durationMinutes => endDateTime.difference(startDateTime).inMinutes;
}
