import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';

class TeamRepository {
  final FirebaseFirestore _firestore;

  TeamRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Team>> getAllTeams() async {
    try {
      final querySnapshot = await _firestore.collection('teams').get();
      return querySnapshot.docs.map((doc) => Team.fromFirestore(doc)).toList();
    } catch (e, stackTrace) {
      print('Error getting all teams: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> createTeam(Team team) async {
    try {
      await _firestore.collection('teams').add(team.toMap());
    } catch (e, stackTrace) {
      print('Error creating team: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).update(team.toMap());
    } catch (e, stackTrace) {
      print('Error updating team: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e, stackTrace) {
      print('Error deleting team: $e');
      print(stackTrace);
      rethrow;
    }
  }
}
