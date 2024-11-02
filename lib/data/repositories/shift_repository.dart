import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shift_model.dart';

class ShiftRepository {
  final FirebaseFirestore _firestore;

  ShiftRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Shift>> getAllShifts() async {
    try {
      final querySnapshot = await _firestore.collection('shifts').get();
      return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
    } catch (e, stackTrace) {
      print('Error getting all shifts: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<List<Shift>> getShiftsForEmployee(String employeeId) async {
    try {
      final querySnapshot = await _firestore.collection('shifts')
          .where('employeeId', isEqualTo: employeeId)
          .get();
      return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
    } catch (e, stackTrace) {
      print('Error getting shifts for employee: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> createShift(Shift shift) async {
    try {
      await _firestore.collection('shifts').add(shift.toMap());
    } catch (e, stackTrace) {
      print('Error creating shift: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> updateShift(Shift shift) async {
    try {
      await _firestore.collection('shifts').doc(shift.id).update(shift.toMap());
    } catch (e, stackTrace) {
      print('Error updating shift: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> deleteShift(String shiftId) async {
    try {
      await _firestore.collection('shifts').doc(shiftId).delete();
    } catch (e, stackTrace) {
      print('Error deleting shift: $e');
      print(stackTrace);
      rethrow;
    }
  }
}
