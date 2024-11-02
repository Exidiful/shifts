import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_model.dart';
import '../models/shift_model.dart';

class EmployeeRepository {
  final CollectionReference _employeesCollection = FirebaseFirestore.instance.collection('employees');
  final CollectionReference _shiftsCollection = FirebaseFirestore.instance.collection('shifts');

  Future<void> createEmployee(Employee employee) async {
    await _employeesCollection.doc(employee.id).set(employee.toFirestore());
  }

  Future<Employee?> getEmployee(String employeeId) async {
    final doc = await _employeesCollection.doc(employeeId).get();
    return doc.exists ? Employee.fromFirestore(doc) : null;
  }

  Future<List<Employee>> getAllEmployees() async {
    final querySnapshot = await _employeesCollection.get();
    return querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _employeesCollection.doc(employee.id).update(employee.toFirestore());
  }

  Future<void> deleteEmployee(String employeeId) async {
    await _employeesCollection.doc(employeeId).delete();
  }

  Stream<List<Employee>> employeesStream() {
    return _employeesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList());
  }

  Future<List<Employee>> getEmployeesByTeam(String teamId) async {
    final querySnapshot = await _employeesCollection.where('teamId', isEqualTo: teamId).get();
    return querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future<List<Employee>> searchEmployees(String query) async {
    final querySnapshot = await _employeesCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .get();
    return querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future<List<Shift>> getEmployeeShifts(String employeeId, DateTime startDate, DateTime endDate) async {
    final querySnapshot = await _shiftsCollection
        .where('employeeId', isEqualTo: employeeId)
        .where('startDateTime', isGreaterThanOrEqualTo: startDate)
        .where('startDateTime', isLessThan: endDate)
        .get();
    return querySnapshot.docs.map((doc) => Shift.fromFirestore(doc)).toList();
  }
}
