import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shifts/data/repositories/employee_repository.dart';
import 'package:shifts/data/repositories/shift_period_repository.dart';
import 'package:shifts/data/repositories/shift_repository.dart';
import 'package:shifts/data/repositories/team_repository.dart';
import 'models/employee_model.dart';
import 'models/shift_model.dart';
import 'models/shift_period_model.dart';
import 'models/team_model.dart';

class EmployeeController extends StateNotifier<AsyncValue<List<Employee>>> {
  final EmployeeRepository _employeeRepository;

  EmployeeController(this._employeeRepository) : super(const AsyncValue.loading()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final employees = await _employeeRepository.getAllEmployees();
      state = AsyncValue.data(employees);
    } catch (e, stackTrace) {
      print('Error loading employees: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _employeeRepository.createEmployee(employee);
      await loadEmployees();
    } catch (e, stackTrace) {
      print('Error adding employee: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _employeeRepository.updateEmployee(employee);
      await loadEmployees();
    } catch (e, stackTrace) {
      print('Error updating employee: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await _employeeRepository.deleteEmployee(employeeId);
      await loadEmployees();
    } catch (e, stackTrace) {
      print('Error deleting employee: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class ShiftController extends StateNotifier<AsyncValue<List<Shift>>> {
  final ShiftRepository _shiftRepository;

  ShiftController(this._shiftRepository) : super(const AsyncValue.loading()) {
    loadShifts();
  }

  Future<void> loadShifts() async {
    try {
      final shifts = await _shiftRepository.getAllShifts();
      state = AsyncValue.data(shifts);
    } catch (e, stackTrace) {
      print('Error loading shifts: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addShift(Shift shift) async {
    try {
      await _shiftRepository.createShift(shift);
      await loadShifts();
    } catch (e, stackTrace) {
      print('Error adding shift: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateShift(Shift shift) async {
    try {
      await _shiftRepository.updateShift(shift);
      await loadShifts();
    } catch (e, stackTrace) {
      print('Error updating shift: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteShift(String shiftId) async {
    try {
      await _shiftRepository.deleteShift(shiftId);
      await loadShifts();
    } catch (e, stackTrace) {
      print('Error deleting shift: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class ShiftPeriodController extends StateNotifier<AsyncValue<List<ShiftPeriod>>> {
  final ShiftPeriodRepository _shiftPeriodRepository;

  ShiftPeriodController(this._shiftPeriodRepository) : super(const AsyncValue.loading()) {
    loadShiftPeriods();
  }

  Future<void> loadShiftPeriods() async {
    try {
      final shiftPeriods = await _shiftPeriodRepository.getAllShiftPeriods();
      state = AsyncValue.data(shiftPeriods);
    } catch (e, stackTrace) {
      print('Error loading shift periods: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _shiftPeriodRepository.createShiftPeriod(shiftPeriod);
      await loadShiftPeriods();
    } catch (e, stackTrace) {
      print('Error adding shift period: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _shiftPeriodRepository.updateShiftPeriod(shiftPeriod);
      await loadShiftPeriods();
    } catch (e, stackTrace) {
      print('Error updating shift period: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteShiftPeriod(String shiftPeriodId) async {
    try {
      await _shiftPeriodRepository.deleteShiftPeriod(shiftPeriodId);
      await loadShiftPeriods();
    } catch (e, stackTrace) {
      print('Error deleting shift period: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class TeamController extends StateNotifier<AsyncValue<List<Team>>> {
  final TeamRepository _teamRepository;

  TeamController(this._teamRepository) : super(const AsyncValue.loading()) {
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      final teams = await _teamRepository.getAllTeams();
      state = AsyncValue.data(teams);
    } catch (e, stackTrace) {
      print('Error loading teams: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addTeam(Team team) async {
    try {
      await _teamRepository.createTeam(team);
      await loadTeams();
    } catch (e, stackTrace) {
      print('Error adding team: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      await _teamRepository.updateTeam(team);
      await loadTeams();
    } catch (e, stackTrace) {
      print('Error updating team: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      await _teamRepository.deleteTeam(teamId);
      await loadTeams();
    } catch (e, stackTrace) {
      print('Error deleting team: $e');
      print(stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Providers
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) => EmployeeRepository());
final shiftRepositoryProvider = Provider<ShiftRepository>((ref) => ShiftRepository());
final shiftPeriodRepositoryProvider = Provider<ShiftPeriodRepository>((ref) => ShiftPeriodRepository());
final teamRepositoryProvider = Provider<TeamRepository>((ref) => TeamRepository());

final employeeControllerProvider = StateNotifierProvider<EmployeeController, AsyncValue<List<Employee>>>((ref) {
  return EmployeeController(ref.watch(employeeRepositoryProvider));
});

final shiftControllerProvider = StateNotifierProvider<ShiftController, AsyncValue<List<Shift>>>((ref) {
  return ShiftController(ref.watch(shiftRepositoryProvider));
});

final shiftPeriodControllerProvider = StateNotifierProvider<ShiftPeriodController, AsyncValue<List<ShiftPeriod>>>((ref) {
  return ShiftPeriodController(ref.watch(shiftPeriodRepositoryProvider));
});

final teamControllerProvider = StateNotifierProvider<TeamController, AsyncValue<List<Team>>>((ref) {
  return TeamController(ref.watch(teamRepositoryProvider));
});

final employeeShiftsProvider = FutureProvider.family<List<Shift>, String>((ref, employeeId) async {
  final shiftRepository = ref.watch(shiftRepositoryProvider);
  return await shiftRepository.getShiftsForEmployee(employeeId);
});
