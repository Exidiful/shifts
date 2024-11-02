import 'package:flutter/material.dart';
import '../../data/models/team_model.dart';

class TeamDetailPage extends StatelessWidget {
  final Team team;

  const TeamDetailPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${team.name}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Description: ${team.description}'),
            const SizedBox(height: 8),
            Text('Manager: ${team.managerName}'),
            // You might want to add a list of team members here
          ],
        ),
      ),
    );
  }
}
