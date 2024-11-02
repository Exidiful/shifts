import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animations/animations.dart';
import '../../data/models/employee_model.dart';
import '../../data/models/shift_model.dart';
import '../../data/models/shift_period_model.dart';
import '../../data/controllers.dart';
import '../../core/theme.dart';

class EmployeeDetailPage extends ConsumerStatefulWidget {
  final Employee employee;

  const EmployeeDetailPage({Key? key, required this.employee}) : super(key: key);

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends ConsumerState<EmployeeDetailPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final shiftsAsyncValue = ref.watch(employeeShiftsProvider(widget.employee.id));
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee.name, style: Theme.of(context).textTheme.headlineMedium),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmployeeInfoCard(context, customTheme),
                const SizedBox(height: 20),
                _buildCalendarSection(shiftsAsyncValue, shiftPeriodsAsyncValue),
                const SizedBox(height: 20),
                _buildShiftList(shiftsAsyncValue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoCard(BuildContext context, CustomThemeExtension? customTheme) {
    return Card(
      color: customTheme?.cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Position: ${widget.employee.position}', style: Theme.of(context).textTheme.titleLarge),
            Text('Email: ${widget.employee.email}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Phone: ${widget.employee.phoneNumber}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Hire Date: ${widget.employee.hireDate.toLocal().toString().split(' ')[0]}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Team ID: ${widget.employee.teamId}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(AsyncValue<List<Shift>> shiftsAsyncValue, AsyncValue<List<ShiftPeriod>> shiftPeriodsAsyncValue) {
    return shiftsAsyncValue.when(
      data: (shifts) => shiftPeriodsAsyncValue.when(
        data: (shiftPeriods) => _buildCalendar(shifts, shiftPeriods),
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('Error loading shift periods'),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error loading shifts'),
    );
  }

  Widget _buildCalendar(List<Shift> shifts, List<ShiftPeriod> shiftPeriods) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (DateTime day) => isSameDay(_selectedDay, day),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (DateTime day) {
        return shifts.where((Shift shift) => isSameDay(shift.startDateTime, day)).toList();
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final shiftsForDay = shifts.where((shift) => isSameDay(shift.startDateTime, day)).toList();
          if (shiftsForDay.isNotEmpty) {
            final shiftPeriod = shiftPeriods.firstWhere((sp) => sp.id == shiftsForDay.first.shiftPeriodId);
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: shiftPeriod.color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShiftList(AsyncValue<List<Shift>> shiftsAsyncValue) {
    return shiftsAsyncValue.when(
      data: (shifts) {
        final selectedDayShifts = shifts.where((shift) => isSameDay(shift.startDateTime, _selectedDay)).toList();
        if (selectedDayShifts.isEmpty) {
          return Text('No shifts for the selected day', style: Theme.of(context).textTheme.bodyLarge);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shifts for ${_selectedDay?.toString().split(' ')[0] ?? 'selected day'}:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...selectedDayShifts.map((shift) => OpenContainer(
              transitionType: ContainerTransitionType.fade,
              openBuilder: (context, _) => _ShiftDetailDialog(shift: shift),
              closedBuilder: (context, openContainer) => Card(
                color: Theme.of(context).extension<CustomThemeExtension>()?.cardBackgroundColor,
                child: ListTile(
                  title: Text('Shift Period: ${shift.shiftPeriodId}', style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text('${shift.startDateTime.toString()} - ${shift.endDateTime.toString()}',
                      style: Theme.of(context).textTheme.bodySmall),
                  onTap: openContainer,
                ),
              ),
            )),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error', style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

class _ShiftDetailDialog extends StatelessWidget {
  final Shift shift;

  const _ShiftDetailDialog({Key? key, required this.shift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Details', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employee ID: ${shift.employeeId}', style: Theme.of(context).textTheme.titleMedium),
            Text('Shift Period: ${shift.shiftPeriodId}', style: Theme.of(context).textTheme.titleMedium),
            Text('Start: ${shift.startDateTime}', style: Theme.of(context).textTheme.bodyLarge),
            Text('End: ${shift.endDateTime}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Duration: ${shift.durationMinutes} minutes', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
