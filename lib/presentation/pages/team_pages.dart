import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/controllers.dart';
import '../../data/models/team_model.dart';
import '../widgets/common_widgets.dart';
import '../../core/theme.dart';

class TeamListPage extends ConsumerWidget {
  const TeamListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsyncValue = ref.watch(teamControllerProvider);
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Teams', style: Theme.of(context).textTheme.headlineMedium),
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
        child: teamsAsyncValue.when(
          data: (teams) => ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) => Card(
              color: customTheme?.cardBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomListItem<Team>(
                item: teams[index],
                title: teams[index].name,
                subtitle: 'Manager: ${teams[index].managerName}',
                onTap: () {
                  // Navigate to team detail page
                },
                onEdit: () {
                  // Show edit team dialog
                },
                confirmDismiss: () async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: 'Confirm Delete',
                      content: Text('Are you sure you want to delete ${teams[index].name}?'),
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
                  ref.read(teamControllerProvider.notifier).deleteTeam(teams[index].id);
                },
              ),
            ),
          ),
          loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
          error: (error, stack) => Center(child: Text('Error: $error', style: Theme.of(context).textTheme.bodyLarge)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add team dialog
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
