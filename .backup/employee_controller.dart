import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/employee_repository.dart';

final employeeControllerProvider = StateNotifierProvider<EmployeeController, AsyncValue<List<Employee>>>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  return EmployeeController(repository);
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) => EmployeeRepository());

class EmployeeController extends StateNotifier<AsyncValue<List<Employee>>> {
  final EmployeeRepository _employeeRepository;

  EmployeeController(this._employeeRepository) : super(const AsyncValue.loading()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final employees = await _employeeRepository.getAllEmployees();
      state = AsyncValue.data(employees);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _employeeRepository.createEmployee(employee);
      await loadEmployees();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _employeeRepository.updateEmployee(employee);
      await loadEmployees();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await _employeeRepository.deleteEmployee(employeeId);
      await loadEmployees();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Employee?> getEmployee(String employeeId) async {
    try {
      return await _employeeRepository.getEmployee(employeeId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Stream<List<Employee>> employeesStream() {
    return _employeeRepository.employeesStream();
  }
}
