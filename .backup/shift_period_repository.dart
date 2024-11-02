import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shift_period_model.dart';

class ShiftPeriodRepository {
  final CollectionReference _shiftPeriodsCollection = FirebaseFirestore.instance.collection('shiftPeriods');

  Future<void> createShiftPeriod(ShiftPeriod shiftPeriod) async {
    // Always generate a new document ID for new shift periods
    final docRef = _shiftPeriodsCollection.doc();
    
    final ShiftPeriod shiftPeriodToSave = ShiftPeriod(
      id: docRef.id,
      name: shiftPeriod.name,
      teamId: shiftPeriod.teamId,
      startHour: shiftPeriod.startHour,
      startMinute: shiftPeriod.startMinute,
      durationMinutes: shiftPeriod.durationMinutes,
      color: shiftPeriod.color,
    );

    // Save the document with the generated ID
    await docRef.set(shiftPeriodToSave.toFirestore());
  }

  Future<ShiftPeriod?> getShiftPeriod(String shiftPeriodId) async {
    final doc = await _shiftPeriodsCollection.doc(shiftPeriodId).get();
    return doc.exists ? ShiftPeriod.fromFirestore(doc) : null;
  }

  Future<List<ShiftPeriod>> getAllShiftPeriods() async {
    final querySnapshot = await _shiftPeriodsCollection.get();
    return querySnapshot.docs.map((doc) => ShiftPeriod.fromFirestore(doc)).toList();
  }

  Future<void> updateShiftPeriod(ShiftPeriod shiftPeriod) async {
    await _shiftPeriodsCollection.doc(shiftPeriod.id).update(shiftPeriod.toFirestore());
  }

  Future<void> deleteShiftPeriod(String shiftPeriodId) async {
    await _shiftPeriodsCollection.doc(shiftPeriodId).delete();
  }

  Stream<List<ShiftPeriod>> shiftPeriodsStream() {
    return _shiftPeriodsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ShiftPeriod.fromFirestore(doc)).toList());
  }

  Future<List<ShiftPeriod>> getShiftPeriodsForTeam(String teamId) async {
    final querySnapshot = await _shiftPeriodsCollection.where('teamId', isEqualTo: teamId).get();
    return querySnapshot.docs.map((doc) => ShiftPeriod.fromFirestore(doc)).toList();
  }

  Future<List<ShiftPeriod>> getShiftPeriodsByTeam(String teamId) async {
    final querySnapshot = await _shiftPeriodsCollection.where('teamId', isEqualTo: teamId).get();
    return querySnapshot.docs.map((doc) => ShiftPeriod.fromFirestore(doc)).toList();
  }
}
