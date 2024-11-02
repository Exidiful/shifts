import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shift_period_model.dart';

class ShiftPeriodRepository {
  final FirebaseFirestore _firestore;

  ShiftPeriodRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ShiftPeriod>> getAllShiftPeriods() async {
    try {
      final querySnapshot = await _firestore.collection('shiftPeriods').get();
      return querySnapshot.docs.map((doc) => ShiftPeriod.fromFirestore(doc)).toList();
    } catch (e, stackTrace) {
      print('Error getting all shift periods: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> createShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _firestore.collection('shiftPeriods').add(shiftPeriod.toMap());
    } catch (e, stackTrace) {
      print('Error creating shift period: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> updateShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _firestore.collection('shiftPeriods').doc(shiftPeriod.id).update(shiftPeriod.toMap());
    } catch (e, stackTrace) {
      print('Error updating shift period: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> deleteShiftPeriod(String shiftPeriodId) async {
    try {
      await _firestore.collection('shiftPeriods').doc(shiftPeriodId).delete();
    } catch (e, stackTrace) {
      print('Error deleting shift period: $e');
      print(stackTrace);
      rethrow;
    }
  }
}
