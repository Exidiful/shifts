import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/controllers.dart';
import '../widgets/common_widgets.dart';
import '../dialogs/add_employee_dialog.dart';
import 'employee_detail_page.dart';
import 'edit_employee_page.dart';
import '../../data/models/employee_model.dart';
import '../../core/theme.dart';

class EmployeeListPage extends ConsumerWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsyncValue = ref.watch(employeeControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Employees', style: Theme.of(context).textTheme.headlineMedium),
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
        child: employeesAsyncValue.when(
          data: (employees) => ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: customTheme?.cardBackgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: CustomListItem<Employee>(
                  item: employees[index],
                  title: employees[index].name,
                  subtitle: employees[index].position,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetailPage(employee: employees[index]),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEmployeePage(employee: employees[index]),
                      ),
                    ).then((_) {
                      // Refresh the list after editing
                      ref.refresh(employeeControllerProvider);
                    });
                  },
                  confirmDismiss: () async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: 'Confirm Delete',
                        content: Text('Are you sure you want to delete ${employees[index].name}?'),
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
                    ref.read(employeeControllerProvider.notifier).deleteEmployee(employees[index].id);
                    // Refresh the list after deleting
                    ref.refresh(employeeControllerProvider);
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddEmployeeDialog(
              onEmployeeAdded: (newEmployee) {
                ref.read(employeeControllerProvider.notifier).addEmployee(newEmployee);
                // Refresh the list after adding
                ref.refresh(employeeControllerProvider);
              },
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: FaIcon(FontAwesomeIcons.plus, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
