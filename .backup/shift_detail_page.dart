import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shift_model.dart';
import '../controllers/shift_controller.dart';
import '../controllers/employee_controller.dart';
import '../controllers/shift_period_controller.dart';

class ShiftDetailPage extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const ShiftDetailPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ShiftDetailPageState createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends ConsumerState<ShiftDetailPage> {
  String? _selectedEmployeeId;
  String? _selectedShiftPeriodId;

  @override
  Widget build(BuildContext context) {
    final employeesAsyncValue = ref.watch(employeeControllerProvider);
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add Shift for ${widget.selectedDate.toString().split(' ')[0]}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            employeesAsyncValue.when(
              data: (employees) => DropdownButtonFormField<String>(
                value: _selectedEmployeeId,
                decoration: const InputDecoration(labelText: 'Select Employee'),
                items: employees.map((employee) {
                  return DropdownMenuItem(
                    value: employee.id,
                    child: Text(employee.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmployeeId = value;
                  });
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),
            shiftPeriodsAsyncValue.when(
              data: (shiftPeriods) => DropdownButtonFormField<String>(
                value: _selectedShiftPeriodId,
                decoration: const InputDecoration(labelText: 'Select Shift Period'),
                items: shiftPeriods.map((shiftPeriod) {
                  return DropdownMenuItem(
                    value: shiftPeriod.id,
                    child: Text(shiftPeriod.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedShiftPeriodId = value;
                  });
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectedEmployeeId != null && _selectedShiftPeriodId != null
                  ? () => _addShift(context)
                  : null,
              child: const Text('Add Shift'),
            ),
          ],
        ),
      ),
    );
  }

  void _addShift(BuildContext context) {
    if (_selectedEmployeeId != null && _selectedShiftPeriodId != null) {
      ref.read(shiftControllerProvider.notifier).addShift(
        Shift(employeeId: _selectedEmployeeId!,startDateTime:  widget.selectedDate, shiftPeriodId: _selectedShiftPeriodId!, id: '', durationMinutes:480));
      Navigator.of(context).pop();
    }
  }
}