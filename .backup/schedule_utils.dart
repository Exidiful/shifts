import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/shift_model.dart';

class ScheduleUtils {
  static final CollectionReference _shiftsCollection = FirebaseFirestore.instance.collection('shifts');

  static Future<bool> isEmployeeAvailable(String employeeId, DateTime startTime, DateTime endTime) async {
    final querySnapshot = await _shiftsCollection
        .where('employeeId', isEqualTo: employeeId)
        .where('startDateTime', isLessThan: endTime)
        .where('startDateTime', isGreaterThanOrEqualTo: startTime)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  static Future<double> getWeeklyHours(String employeeId, DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final shifts = await _getShiftsForPeriod(employeeId, weekStart, weekEnd);
    return _calculateTotalHours(shifts);
  }

  static Future<double> getMonthlyHours(String employeeId, DateTime monthStart) async {
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 1);
    final shifts = await _getShiftsForPeriod(employeeId, monthStart, monthEnd);
    return _calculateTotalHours(shifts);
  }

  static Future<List<Shift>> getTeamSchedule(String teamId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('teamId', isEqualTo: teamId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  static Future<List<Shift>> getEmployeeSchedule(String employeeId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('employeeId', isEqualTo: employeeId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  static Future<List<Shift>> _getShiftsForPeriod(String employeeId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('employeeId', isEqualTo: employeeId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }
   static double _calculateTotalHours(List<Shift> shifts) {
    return shifts.length * 8.0;
  } 
}