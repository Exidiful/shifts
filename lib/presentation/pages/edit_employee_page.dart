import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';
import '../../data/controllers.dart';
import '../../core/theme.dart';

class EditEmployeePage extends ConsumerStatefulWidget {
  final Employee employee;

  const EditEmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends ConsumerState<EditEmployeePage> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _positionController = TextEditingController(text: widget.employee.position);
    _emailController = TextEditingController(text: widget.employee.email);
    _phoneController = TextEditingController(text: widget.employee.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.employee.name}', style: Theme.of(context).textTheme.headlineMedium),
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
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  TextField(
                    controller: _positionController,
                    decoration: InputDecoration(
                      labelText: 'Position',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveEmployee,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('Save Changes', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveEmployee() {
    final updatedEmployee = Employee(
      id: widget.employee.id,
      name: _nameController.text,
      position: _positionController.text,
      teamId: widget.employee.teamId,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      hireDate: widget.employee.hireDate,
    );
    ref.read(employeeControllerProvider.notifier).updateEmployee(updatedEmployee);
    Navigator.pop(context, updatedEmployee);
  }
}
