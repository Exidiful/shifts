import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/controllers.dart';
import '../widgets/common_widgets.dart';
import '../../data/models/shift_period_model.dart';
import '../../core/theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ShiftPeriodListPage extends ConsumerWidget {
  const ShiftPeriodListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftPeriodsAsyncValue = ref.watch(shiftPeriodControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: const BlurredAppBar(title: 'Shift Periods'),
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
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: customTheme?.cardBackgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Color: ', style: Theme.of(context).textTheme.bodyMedium),
                Container(
                  width: 20,
                  height: 20,
                  color: shiftPeriod.color,
                ),
              ],
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
    showDialog(
      context: context,
      builder: (BuildContext context) => _ShiftPeriodDialog(
        shiftPeriod: shiftPeriod,
        onSave: (updatedShiftPeriod) {
          ref.read(shiftPeriodControllerProvider.notifier).updateShiftPeriod(updatedShiftPeriod);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showAddShiftPeriodDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _ShiftPeriodDialog(
        onSave: (newShiftPeriod) {
          ref.read(shiftPeriodControllerProvider.notifier).addShiftPeriod(newShiftPeriod);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _ShiftPeriodDialog extends StatefulWidget {
  final ShiftPeriod? shiftPeriod;
  final Function(ShiftPeriod) onSave;

  const _ShiftPeriodDialog({Key? key, this.shiftPeriod, required this.onSave}) : super(key: key);

  @override
  _ShiftPeriodDialogState createState() => _ShiftPeriodDialogState();
}

class _ShiftPeriodDialogState extends State<_ShiftPeriodDialog> {
  late TextEditingController _nameController;
  late TextEditingController _startHourController;
  late TextEditingController _startMinuteController;
  late TextEditingController _durationController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shiftPeriod?.name ?? '');
    _startHourController = TextEditingController(text: widget.shiftPeriod?.startHour.toString() ?? '');
    _startMinuteController = TextEditingController(text: widget.shiftPeriod?.startMinute.toString() ?? '');
    _durationController = TextEditingController(text: widget.shiftPeriod?.durationMinutes.toString() ?? '');
    _selectedColor = widget.shiftPeriod?.color ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shiftPeriod == null ? 'Add Shift Period' : 'Edit Shift Period'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _startHourController,
              decoration: const InputDecoration(labelText: 'Start Hour'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _startMinuteController,
              decoration: const InputDecoration(labelText: 'Start Minute'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _selectedColor,
                          onColorChanged: (Color color) {
                            setState(() => _selectedColor = color);
                          },
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Got it'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: _selectedColor),
              child: Text('Select Color'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final shiftPeriod = ShiftPeriod(
              id: widget.shiftPeriod?.id ?? DateTime.now().toString(),
              name: _nameController.text,
              startHour: int.parse(_startHourController.text),
              startMinute: int.parse(_startMinuteController.text),
              durationMinutes: int.parse(_durationController.text),
              color: _selectedColor,
            );
            widget.onSave(shiftPeriod);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startHourController.dispose();
    _startMinuteController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
