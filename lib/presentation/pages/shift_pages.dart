import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/controllers.dart';
import '../../data/models/shift_model.dart';
import '../../data/models/shift_period_model.dart';
import '../../data/models/employee_model.dart';
import '../../core/theme.dart';

class ShiftDetailPage extends ConsumerStatefulWidget {
  final Shift? shift;

  const ShiftDetailPage({Key? key, this.shift}) : super(key: key);

  @override
  _ShiftDetailPageState createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends ConsumerState<ShiftDetailPage> {
  late DateTime selectedDate;
  String? selectedEmployeeId;
  String? selectedShiftPeriodId;
  ShiftPeriod? selectedShiftPeriod;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.shift?.startDateTime ?? DateTime.now();
    selectedEmployeeId = widget.shift?.employeeId;
    selectedShiftPeriodId = widget.shift?.shiftPeriodId;
  }

  @override
  Widget build(BuildContext context) {
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);
    final employeesAsyncValue = ref.watch(employeeControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shift == null ? 'Add Shift' : 'Edit Shift', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: customTheme?.cardBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Employee:', style: Theme.of(context).textTheme.bodyLarge),
                  employeesAsyncValue.when(
                    data: (employees) => DropdownButton<String>(
                      value: selectedEmployeeId,
                      items: employees.map((Employee employee) {
                        return DropdownMenuItem<String>(
                          value: employee.id,
                          child: Text(employee.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEmployeeId = newValue;
                        });
                      },
                      dropdownColor: customTheme?.cardBackgroundColor,
                    ),
                    loading: () => CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                    error: (error, stack) => Text('Error: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                  const SizedBox(height: 16),
                  Text('Shift Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}', style: Theme.of(context).textTheme.bodyLarge),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('Change Date'),
                  ),
                  const SizedBox(height: 16),
                  Text('Shift Period:', style: Theme.of(context).textTheme.bodyLarge),
                  shiftPeriodsAsyncValue.when(
                    data: (shiftPeriods) => DropdownButton<String>(
                      value: selectedShiftPeriodId,
                      items: shiftPeriods.map((ShiftPeriod shiftPeriod) {
                        return DropdownMenuItem<String>(
                          value: shiftPeriod.id,
                          child: Text(shiftPeriod.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedShiftPeriodId = newValue;
                          selectedShiftPeriod = shiftPeriods.firstWhere((sp) => sp.id == newValue);
                        });
                      },
                      dropdownColor: customTheme?.cardBackgroundColor,
                    ),
                    loading: () => CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                    error: (error, stack) => Text('Error: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveShift,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('Save Shift'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveShift() {
    if (selectedEmployeeId == null || selectedShiftPeriodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee and a shift period')),
      );
      return;
    }

    final newShift = Shift(
      id: widget.shift?.id ?? DateTime.now().toString(),
      employeeId: selectedEmployeeId!,
      startDateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedShiftPeriod?.startHour ?? 0,
        selectedShiftPeriod?.startMinute ?? 0,
      ),
      endDateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedShiftPeriod?.startHour ?? 0,
        selectedShiftPeriod?.startMinute ?? 0,
      ).add(Duration(minutes: selectedShiftPeriod?.durationMinutes ?? 0)),
      shiftPeriodId: selectedShiftPeriodId!,
    );

    if (widget.shift == null) {
      ref.read(shiftControllerProvider.notifier).addShift(newShift);
    } else {
      ref.read(shiftControllerProvider.notifier).updateShift(newShift);
    }

    Navigator.of(context).pop();
  }
}
