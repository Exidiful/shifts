import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/team_model.dart';
import '../controllers/team_controller.dart';
import 'team_detail_page.dart';

class TeamListPage extends ConsumerWidget {
  const TeamListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsyncValue = ref.watch(teamControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: teamsAsyncValue.when(
        data: (teams) => ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return ListTile(
              title: Text(team.name),
              subtitle: Text(team.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteTeam(context, ref, team.id),
              ),
              onTap: () => _navigateToTeamDetail(context, ref, team),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTeamDetail(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToTeamDetail(BuildContext context, WidgetRef ref, Team? team) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeamDetailPage(team: team),
      ),
    );
  }

  void _deleteTeam(BuildContext context, WidgetRef ref, String teamId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: const Text('Are you sure you want to delete this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(teamControllerProvider.notifier).deleteTeam(teamId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}