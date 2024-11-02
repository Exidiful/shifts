import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shifts/data/models/shift_model.dart';
import 'package:shifts/data/models/shift_period_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/shift_controller.dart';
import '../controllers/shift_period_controller.dart';
import 'shift_detail_page.dart';

class ShiftListPage extends ConsumerStatefulWidget {
  const ShiftListPage({Key? key}) : super(key: key);

  @override
  _ShiftListPageState createState() => _ShiftListPageState();
}

class _ShiftListPageState extends ConsumerState<ShiftListPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final shiftsAsyncValue = ref.watch(shiftControllerProvider);
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shifts')),
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
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return shiftPeriodsAsyncValue.when(
                    data: (shiftPeriods) {
                      final shiftPeriod = shiftPeriods.firstWhere(
                        (sp) => sp.id == (events.first as Shift).shiftPeriodId,
                        orElse: () => ShiftPeriod(id: '', name: '', teamId: '', startHour: 0, startMinute: 0, durationMinutes: 0),
                      );
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: shiftPeriod.color,
                          ),
                          width: 8.0,
                          height: 8.0,
                        ),
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: shiftsAsyncValue.when(
              data: (shifts) {
                final dayShifts = shifts.where((shift) => isSameDay(shift.startDateTime, _selectedDay)).toList();
                return ListView.builder(
                  itemCount: dayShifts.length,
                  itemBuilder: (context, index) {
                    final shift = dayShifts[index];
                    return ListTile(
                      title: Text('Employee ID: ${shift.employeeId}'),
                      subtitle: Text('Start Time: ${shift.startDateTime.toString()}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ShiftDetailPage(selectedDate: _selectedDay ?? DateTime.now()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}