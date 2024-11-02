import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';
import '../models/employee_model.dart';

class TeamRepository {
  final CollectionReference _teamsCollection = FirebaseFirestore.instance.collection('teams');
  final CollectionReference _employeesCollection = FirebaseFirestore.instance.collection('employees');

  Future<void> createTeam(Team team) async {
    await _teamsCollection.doc(team.id).set(team.toFirestore());
  }

  Future<Team?> getTeam(String teamId) async {
    final doc = await _teamsCollection.doc(teamId).get();
    return doc.exists ? Team.fromFirestore(doc) : null;
  }

  Future<List<Team>> getAllTeams() async {
    final querySnapshot = await _teamsCollection.get();
    return querySnapshot.docs.map((doc) => Team.fromFirestore(doc)).toList();
  }

  Future<void> updateTeam(Team team) async {
    await _teamsCollection.doc(team.id).update(team.toFirestore());
  }

  Future<void> deleteTeam(String teamId) async {
    await _teamsCollection.doc(teamId).delete();
  }

  Stream<List<Team>> teamsStream() {
    return _teamsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList());
  }

  Future<List<Employee>> getTeamMembers(String teamId) async {
    final querySnapshot = await _employeesCollection.where('teamId', isEqualTo: teamId).get();
    return querySnapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
  }

  Future<void> addEmployeeToTeam(String employeeId, String teamId) async {
    await _employeesCollection.doc(employeeId).update({'teamId': teamId});
  }

  Future<void> removeEmployeeFromTeam(String employeeId, String teamId) async {
    await _employeesCollection.doc(employeeId).update({'teamId': null});
  }
}
