import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shift_period_model.dart';
import '../controllers/shift_period_controller.dart';
import 'shift_period_detail_page.dart';

class ShiftPeriodListPage extends ConsumerWidget {
  const ShiftPeriodListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shift Periods')),
      body: shiftPeriodsAsyncValue.when(
        data: (shiftPeriods) => ListView.builder(
          itemCount: shiftPeriods.length,
          itemBuilder: (context, index) {
            final shiftPeriod = shiftPeriods[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: shiftPeriod.color,
              ),
              title: Text(shiftPeriod.name),
              subtitle: Text('${shiftPeriod.startHour.toString().padLeft(2, '0')}:${shiftPeriod.startMinute.toString().padLeft(2, '0')} - Duration: ${shiftPeriod.durationMinutes} minutes'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteShiftPeriod(context, ref, shiftPeriod.id),
              ),
              onTap: () => _navigateToShiftPeriodDetail(context, ref, shiftPeriod),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: SelectableText(
            'Error: $error\n\nStack Trace:\n$stack',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToShiftPeriodDetail(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToShiftPeriodDetail(BuildContext context, WidgetRef ref, ShiftPeriod? shiftPeriod) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShiftPeriodDetailPage(shiftPeriod: shiftPeriod),
      ),
    );
  }

  void _deleteShiftPeriod(BuildContext context, WidgetRef ref, String shiftPeriodId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shift Period'),
        content: const Text('Are you sure you want to delete this shift period?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(shiftPeriodControllerProvider.notifier).deleteShiftPeriod(shiftPeriodId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}