import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/team_model.dart';
import '../../data/repositories/team_repository.dart';

final teamControllerProvider = StateNotifierProvider<TeamController, AsyncValue<List<Team>>>((ref) {
  final repository = ref.watch(teamRepositoryProvider);
  return TeamController(repository);
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) => TeamRepository());

class TeamController extends StateNotifier<AsyncValue<List<Team>>> {
  final TeamRepository _teamRepository;

  TeamController(this._teamRepository) : super(const AsyncValue.loading()) {
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      final teams = await _teamRepository.getAllTeams();
      state = AsyncValue.data(teams);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addTeam(Team team) async {
    try {
      await _teamRepository.createTeam(team);
      await loadTeams();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      await _teamRepository.updateTeam(team);
      await loadTeams();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      await _teamRepository.deleteTeam(teamId);
      await loadTeams();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<Team?> getTeam(String teamId) async {
    try {
      return await _teamRepository.getTeam(teamId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Stream<List<Team>> teamsStream() {
    return _teamRepository.teamsStream();
  }
}