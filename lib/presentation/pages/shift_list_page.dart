import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shifts/presentation/pages/shift_pages.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/shift_model.dart';
import '../../data/controllers.dart';
import '../pages/shift_period_list_page.dart';
import '../widgets/common_widgets.dart';
import '../../core/theme.dart';

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
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shifts', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.clock, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShiftPeriodListPage()),
              );
            },
          ),
        ],
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
        child: Column(
          children: [
            _buildCalendar(shiftsAsyncValue),
            Expanded(child: _buildShiftList(shiftsAsyncValue)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShiftDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: FaIcon(FontAwesomeIcons.plus, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildCalendar(AsyncValue<List<Shift>> shiftsAsyncValue) {
    return TableCalendar<Shift>(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
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
    );
  }

  Widget _buildShiftList(AsyncValue<List<Shift>> shiftsAsyncValue) {
    return shiftsAsyncValue.when(
      data: (shifts) {
        final selectedDayShifts = shifts.where((shift) => isSameDay(shift.startDateTime, _selectedDay)).toList();
        if (selectedDayShifts.isEmpty) {
          return Center(child: Text('No shifts for the selected day', style: Theme.of(context).textTheme.bodyLarge));
        }
        return ListView.builder(
          itemCount: selectedDayShifts.length,
          itemBuilder: (context, index) => Card(
            color: Theme.of(context).extension<CustomThemeExtension>()?.cardBackgroundColor,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomListItem<Shift>(
              item: selectedDayShifts[index],
              title: selectedDayShifts[index].employeeId,
              subtitle: '${selectedDayShifts[index].startDateTime.toString()} - ${selectedDayShifts[index].endDateTime.toString()}',
              onTap: () {},
              onEdit: () => _showEditShiftDialog(context, selectedDayShifts[index]),
              confirmDismiss: () async {
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => CustomDialog(
                    title: 'Confirm Delete',
                    content: const Text('Are you sure you want to delete this shift?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
                ) ?? false;
              },
              onDismiss: () {
                ref.read(shiftControllerProvider.notifier).deleteShift(selectedDayShifts[index].id);
              },
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
      error: (error, _) => Center(child: Text('Error: $error', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }

  void _showAddShiftDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShiftDetailPage(),
      ),
    ).then((_) {
      // Refresh the list after adding
      ref.refresh(shiftControllerProvider);
    });
  }

  void _showEditShiftDialog(BuildContext context, Shift shift) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShiftDetailPage(shift: shift),
      ),
    ).then((_) {
      // Refresh the list after editing
      ref.refresh(shiftControllerProvider);
    });
  }
}
