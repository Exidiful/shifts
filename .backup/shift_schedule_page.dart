import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/shift_controller.dart';
import '../controllers/shift_period_controller.dart';

class ShiftSchedulePage extends ConsumerStatefulWidget {
  const ShiftSchedulePage({Key? key}) : super(key: key);

  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends ConsumerState<ShiftSchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final shiftsAsyncValue = ref.watch(shiftControllerProvider);
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shift Schedule')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay, ) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return shiftsAsyncValue.when(
                data: (shifts) => shifts.where((shift) => isSameDay(shift.startDateTime, day)).toList(),
                loading: () => [],
                error: (_, __) => [],
              );
            },
            // ... (rest of the calendar configuration)
          ),
          // ... (rest of the UI)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/shift_detail',
            arguments: {'selectedDate': _selectedDay ?? DateTime.now()},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
