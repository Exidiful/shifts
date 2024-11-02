import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/employee_model.dart';
import '../controllers/employee_controller.dart';
import 'employee_detail_page.dart';

class EmployeeListPage extends ConsumerWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsyncValue = ref.watch(employeeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: employeesAsyncValue.when(
        data: (employees) => ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return ListTile(
              title: Text(employee.name),
              subtitle: Text(employee.position),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteEmployee(context, ref, employee.id),
              ),
              onTap: () => _navigateToEmployeeDetail(context, ref, employee),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEmployeeDetail(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEmployeeDetail(BuildContext context, WidgetRef ref, Employee? employee) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmployeeDetailPage(employee: employee),
      ),
    );
  }

  void _deleteEmployee(BuildContext context, WidgetRef ref, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(employeeControllerProvider.notifier).deleteEmployee(employeeId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
