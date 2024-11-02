import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../data/models/shift_period_model.dart';
import '../controllers/shift_period_controller.dart';
import '../controllers/team_controller.dart';

class ShiftPeriodDetailPage extends ConsumerStatefulWidget {
  final ShiftPeriod? shiftPeriod;

  const ShiftPeriodDetailPage({Key? key, this.shiftPeriod}) : super(key: key);

  @override
  _ShiftPeriodDetailPageState createState() => _ShiftPeriodDetailPageState();
}

class _ShiftPeriodDetailPageState extends ConsumerState<ShiftPeriodDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _startHourController;
  late TextEditingController _startMinuteController;
  late TextEditingController _durationMinutesController;
  late String? _selectedTeamId;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shiftPeriod?.name ?? '');
    _startHourController = TextEditingController(text: widget.shiftPeriod?.startHour.toString() ?? '');
    _startMinuteController = TextEditingController(text: widget.shiftPeriod?.startMinute.toString() ?? '');
    _durationMinutesController = TextEditingController(text: widget.shiftPeriod?.durationMinutes.toString() ?? '');
    _selectedTeamId = widget.shiftPeriod?.teamId;
    _selectedColor = widget.shiftPeriod?.color ?? Colors.blue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startHourController.dispose();
    _startMinuteController.dispose();
    _durationMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsyncValue = ref.watch(teamControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shiftPeriod == null ? 'Add Shift Period' : 'Edit Shift Period'),
      ),
      body: teamsAsyncValue.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('Please create a team first'));
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Shift Period Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a shift period name';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedTeamId,
                  decoration: const InputDecoration(labelText: 'Team'),
                  items: teams.map((team) {
                    return DropdownMenuItem(
                      value: team.id,
                      child: Text(team.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeamId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a team';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startHourController,
                  decoration: const InputDecoration(labelText: 'Start Hour (0-23)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a start hour';
                    }
                    final hour = int.tryParse(value);
                    if (hour == null || hour < 0 || hour > 23) {
                      return 'Please enter a valid hour (0-23)';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startMinuteController,
                  decoration: const InputDecoration(labelText: 'Start Minute (0-59)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a start minute';
                    }
                    final minute = int.tryParse(value);
                    if (minute == null || minute < 0 || minute > 59) {
                      return 'Please enter a valid minute (0-59)';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _durationMinutesController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a duration';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration <= 0) {
                      return 'Please enter a valid duration (greater than 0)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Shift Period Color'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveShiftPeriod,
                  child: Text(widget.shiftPeriod == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              'Error: $error\n\nStack Trace:\n$stack',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }

  void _saveShiftPeriod() {
    if (_formKey.currentState!.validate()) {
      final shiftPeriod = ShiftPeriod(
        id: widget.shiftPeriod?.id ?? '', // Use an empty string for new shift periods
        name: _nameController.text,
        teamId: _selectedTeamId!,
        startHour: int.parse(_startHourController.text),
        startMinute: int.parse(_startMinuteController.text),
        durationMinutes: int.parse(_durationMinutesController.text),
        color: _selectedColor,
      );

      if (widget.shiftPeriod == null) {
        ref.read(shiftPeriodControllerProvider.notifier).addShiftPeriod(shiftPeriod);
      } else {
        ref.read(shiftPeriodControllerProvider.notifier).updateShiftPeriod(shiftPeriod);
      }

      Navigator.of(context).pop();
    }
  }
}