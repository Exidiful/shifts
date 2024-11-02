import 'package:flutter/material.dart';
import 'package:shifts/core/theme.dart';
import '../../data/models/employee_model.dart';
import '../widgets/common_widgets.dart';

class AddEmployeeDialog extends StatefulWidget {
  final Function(Employee) onEmployeeAdded;

  const AddEmployeeDialog({Key? key, required this.onEmployeeAdded}) : super(key: key);

  @override
  _AddEmployeeDialogState createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String position = '';
  String email = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return CustomDialog(
      title: 'Add New Employee',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                filled: true,
                fillColor: customTheme?.cardBackgroundColor,
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Position',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                filled: true,
                fillColor: customTheme?.cardBackgroundColor,
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              validator: (value) => value!.isEmpty ? 'Please enter a position' : null,
              onSaved: (value) => position = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                filled: true,
                fillColor: customTheme?.cardBackgroundColor,
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              onSaved: (value) => email = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                filled: true,
                fillColor: customTheme?.cardBackgroundColor,
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
              onSaved: (value) => phoneNumber = value!,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newEmployee = Employee(
                id: DateTime.now().toString(), // This is just a placeholder, you should generate a proper ID
                name: name,
                position: position,
                teamId: '', // You might want to add a team selection here
                email: email,
                phoneNumber: phoneNumber,
                hireDate: DateTime.now(),
              );
              widget.onEmployeeAdded(newEmployee);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text('Add', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ],
    );
  }
}
