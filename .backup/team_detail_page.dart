import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/team_model.dart';
import '../controllers/team_controller.dart';

class TeamDetailPage extends ConsumerStatefulWidget {
  final Team? team;

  const TeamDetailPage({Key? key, this.team}) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends ConsumerState<TeamDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _managerIdController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team?.name ?? '');
    _descriptionController = TextEditingController(text: widget.team?.description ?? '');
    _managerIdController = TextEditingController(text: widget.team?.managerId ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _managerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team == null ? 'Add Team' : 'Edit Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _managerIdController,
                decoration: const InputDecoration(labelText: 'Manager ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a manager ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTeam,
                child: Text(widget.team == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTeam() {
    if (_formKey.currentState!.validate()) {
      final team = Team(
        id: widget.team?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        managerId: _managerIdController.text,
      );

      if (widget.team == null) {
        ref.read(teamControllerProvider.notifier).addTeam(team);
      } else {
        ref.read(teamControllerProvider.notifier).updateTeam(team);
      }

      Navigator.of(context).pop();
    }
  }
}