import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';
import '../controllers/employee_controller.dart';
import '../controllers/team_controller.dart';

class EmployeeDetailPage extends ConsumerStatefulWidget {
  final Employee? employee;

  const EmployeeDetailPage({Key? key, this.employee}) : super(key: key);

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends ConsumerState<EmployeeDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String? _selectedTeamId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phoneNumber ?? '');
    _selectedTeamId = widget.employee?.teamId;
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
    final teamsAsyncValue = ref.watch(teamControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: teamsAsyncValue.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(child: Text('Please create a team first'));
          }
          return Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _positionController,
                  decoration: const InputDecoration(labelText: 'Position'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a position';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveEmployee,
                  child: Text(widget.employee == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        position: _positionController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        teamId: _selectedTeamId!,
        hireDate: widget.employee?.hireDate ?? DateTime.now(),
      );

      if (widget.employee == null) {
        ref.read(employeeControllerProvider.notifier).addEmployee(employee);
      } else {
        ref.read(employeeControllerProvider.notifier).updateEmployee(employee);
      }

      Navigator.of(context).pop();
    }
  }
}
