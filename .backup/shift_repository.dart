import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shift_model.dart';

class ShiftRepository {
  final CollectionReference _shiftsCollection = FirebaseFirestore.instance.collection('shifts');

  Future<void> createShift(Shift shift) async {
    await _shiftsCollection.add(shift.toFirestore());
  }

  Future<Shift?> getShift(String shiftId) async {
    final doc = await _shiftsCollection.doc(shiftId).get();
    return doc.exists ? Shift.fromFirestore(doc) : null;
  }

  Future<List<Shift>> getAllShifts() async {
    final querySnapshot = await _shiftsCollection.get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  Future<void> updateShift(Shift shift) async {
    await _shiftsCollection.doc(shift.id).update(shift.toFirestore());
  }

  Future<void> deleteShift(String shiftId) async {
    await _shiftsCollection.doc(shiftId).delete();
  }

  Stream<List<Shift>> shiftsStream() {
    return _shiftsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList());
  }

  Future<List<Shift>> getShiftsForEmployee(String employeeId) async {
    final querySnapshot = await _shiftsCollection.where('employeeId', isEqualTo: employeeId).get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  Future<List<Shift>> getShiftsForTimeRange(DateTime start, DateTime end) async {
    final querySnapshot = await _shiftsCollection
        .where('startDateTime', isGreaterThanOrEqualTo: start)
        .where('startDateTime', isLessThan: end)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  Future<List<Shift>> getShiftsByEmployee(String employeeId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('employeeId', isEqualTo: employeeId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  Future<List<Shift>> getShiftsByTeam(String teamId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('teamId', isEqualTo: teamId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }

  Future<List<Shift>> getShiftsForPeriod(String shiftPeriodId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('shiftPeriodId', isEqualTo: shiftPeriodId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }
}
