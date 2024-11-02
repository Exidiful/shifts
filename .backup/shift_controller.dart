import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shifts/presentation/controllers/shift_period_controller.dart';
import '../../data/models/shift_model.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/repositories/shift_period_repository.dart';

final shiftControllerProvider = StateNotifierProvider<ShiftController, AsyncValue<List<Shift>>>((ref) {
  final repository = ref.watch(shiftRepositoryProvider);
  final shiftPeriodRepository = ref.watch(shiftPeriodRepositoryProvider);
  return ShiftController(repository, shiftPeriodRepository);
});

final shiftRepositoryProvider = Provider<ShiftRepository>((ref) => ShiftRepository());

class ShiftController extends StateNotifier<AsyncValue<List<Shift>>> {
  final ShiftRepository _repository;
  final ShiftPeriodRepository _shiftPeriodRepository;

  ShiftController(this._repository, this._shiftPeriodRepository) : super(const AsyncValue.loading()) {
    loadShifts();
  }

  Future<void> loadShifts() async {
    state = const AsyncValue.loading();
    try {
      final shifts = await _repository.getAllShifts();
      state = AsyncValue.data(shifts);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<List<Shift>> getShiftsForDay(DateTime day) async {
    final allShifts = state.value ?? [];
    return allShifts.where((shift) => 
      shift.startDateTime.year == day.year &&
      shift.startDateTime.month == day.month &&
      shift.startDateTime.day == day.day
    ).toList();
  }

  Future<void> addShift(Shift shift) async {
    try {
      await _repository.createShift(shift);
      await loadShifts();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Future<void> addShift(String employeeId, DateTime startDateTime, String shiftPeriodId) async {
  //   try {
  //     final newShift = Shift(
  //       id: '', // This will be generated by Firestore
  //       employeeId: employeeId,
  //       startDateTime: startDateTime,
  //       shiftPeriodId: shiftPeriodId,
  //     );
  //     await _repository.createShift(newShift);
  //     await loadShifts(); // Reload shifts after adding
  //   } catch (e) {
  //     state = AsyncValue.error(e, StackTrace.current);
  //   }
  // }

  Future<void> updateShift(Shift shift) async {
    try {
      await _repository.updateShift(shift);
      await loadShifts();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteShift(String shiftId) async {
    try {
      await _repository.deleteShift(shiftId);
      await loadShifts();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Shift?> getShift(String shiftId) async {
    try {
      return await _repository.getShift(shiftId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<List<Shift>> getShiftsForEmployee(String employeeId) async {
    try {
      return await _repository.getShiftsForEmployee(employeeId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Shift>> getShiftsForTimeRange(DateTime start, DateTime end) async {
    try {
      return await _repository.getShiftsForTimeRange(start, end);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Stream<List<Shift>> shiftsStream() {
    return _repository.shiftsStream();
  }

  Future<bool> isEmployeeAvailable(String employeeId, DateTime startDateTime, String shiftPeriodId) async {
    final shiftPeriod = await _shiftPeriodRepository.getShiftPeriod(shiftPeriodId);
    if (shiftPeriod == null) return false;

    final endDateTime = startDateTime.add(Duration(minutes: shiftPeriod.durationMinutes));
    
    // Check for conflicts with existing shifts
    final existingShifts = await _repository.getShiftsForEmployee(employeeId);
    for (final shift in existingShifts) {
      final existingShiftPeriod = await _shiftPeriodRepository.getShiftPeriod(shift.shiftPeriodId);
      if (existingShiftPeriod == null) continue;

      final existingEndDateTime = shift.startDateTime.add(Duration(minutes: existingShiftPeriod.durationMinutes));

      if ((startDateTime.isBefore(existingEndDateTime) && endDateTime.isAfter(shift.startDateTime)) ||
          (startDateTime.isAtSameMomentAs(shift.startDateTime) && endDateTime.isAtSameMomentAs(existingEndDateTime))) {
        return false;
      }
    }

    return true;
  }
}