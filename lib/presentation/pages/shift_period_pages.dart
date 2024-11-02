import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/controllers.dart';
import '../widgets/common_widgets.dart';
import '../../data/models/shift_period_model.dart';
import '../../core/theme.dart';

class ShiftPeriodListPage extends ConsumerWidget {
  const ShiftPeriodListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Periods', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
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
        child: shiftPeriodsAsyncValue.when(
          data: (shiftPeriods) => ListView.builder(
            itemCount: shiftPeriods.length,
            itemBuilder: (context, index) => Card(
              color: customTheme?.cardBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomListItem<ShiftPeriod>(
                item: shiftPeriods[index],
                title: shiftPeriods[index].name,
                subtitle: '${shiftPeriods[index].startHour}:${shiftPeriods[index].startMinute.toString().padLeft(2, '0')} - ${shiftPeriods[index].durationMinutes} minutes',
                onTap: () => _showShiftPeriodDetails(context, shiftPeriods[index]),
                onEdit: () => _showEditShiftPeriodDialog(context, ref, shiftPeriods[index]),
                confirmDismiss: () async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: 'Confirm Delete',
                      content: Text('Are you sure you want to delete ${shiftPeriods[index].name}?'),
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
                  ref.read(shiftPeriodControllerProvider.notifier).deleteShiftPeriod(shiftPeriods[index].id);
                },
              ),
            ),
          ),
          loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
          error: (error, stack) => Center(child: Text('Error: $error', style: Theme.of(context).textTheme.bodyLarge)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShiftPeriodDialog(context, ref),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  void _showShiftPeriodDetails(BuildContext context, ShiftPeriod shiftPeriod) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Shift Period Details',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${shiftPeriod.name}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Start Time: ${shiftPeriod.startHour}:${shiftPeriod.startMinute.toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Duration: ${shiftPeriod.durationMinutes} minutes', style: Theme.of(context).textTheme.bodyMedium),
            Container(
              width: 20,
              height: 20,
              color: shiftPeriod.color,
              margin: const EdgeInsets.only(top: 8),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  void _showEditShiftPeriodDialog(BuildContext context, WidgetRef ref, ShiftPeriod shiftPeriod) {
    final nameController = TextEditingController(text: shiftPeriod.name);
    final startHourController = TextEditingController(text: shiftPeriod.startHour.toString());
    final startMinuteController = TextEditingController(text: shiftPeriod.startMinute.toString());
    final durationController = TextEditingController(text: shiftPeriod.durationMinutes.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Edit Shift Period',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: startHourController,
              decoration: const InputDecoration(labelText: 'Start Hour'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: startMinuteController,
              decoration: const InputDecoration(labelText: 'Start Minute'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedShiftPeriod = ShiftPeriod(
                id: shiftPeriod.id,
                name: nameController.text,
                startHour: int.parse(startHourController.text),
                startMinute: int.parse(startMinuteController.text),
                durationMinutes: int.parse(durationController.text),
                color: shiftPeriod.color,
              );
              ref.read(shiftPeriodControllerProvider.notifier).updateShiftPeriod(updatedShiftPeriod);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddShiftPeriodDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final startHourController = TextEditingController();
    final startMinuteController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Add Shift Period',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: startHourController,
              decoration: const InputDecoration(labelText: 'Start Hour'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: startMinuteController,
              decoration: const InputDecoration(labelText: 'Start Minute'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newShiftPeriod = ShiftPeriod(
                id: DateTime.now().toString(), // This is just a placeholder, you should generate a proper ID
                name: nameController.text,
                startHour: int.parse(startHourController.text),
                startMinute: int.parse(startMinuteController.text),
                durationMinutes: int.parse(durationController.text),
                color: Colors.blue, // You might want to add a color picker here
              );
              ref.read(shiftPeriodControllerProvider.notifier).addShiftPeriod(newShiftPeriod);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ... Rest of the file (ShiftPeriodDetailPage, etc.) ...
