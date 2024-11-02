import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  final FirebaseFirestore _firestore;

  EmployeeRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Employee>> getAllEmployees() async {
    try {
      final querySnapshot = await _firestore.collection('employees').get();
      return querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
    } catch (e, stackTrace) {
      print('Error getting all employees: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> createEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').add(employee.toMap());
    } catch (e, stackTrace) {
      print('Error creating employee: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id).update(employee.toMap());
    } catch (e, stackTrace) {
      print('Error updating employee: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await _firestore.collection('employees').doc(employeeId).delete();
    } catch (e, stackTrace) {
      print('Error deleting employee: $e');
      print(stackTrace);
      rethrow;
    }
  }
}
