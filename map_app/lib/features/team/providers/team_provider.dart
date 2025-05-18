import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/team_model.dart';
import '../../../services/api/team_service.dart';

final teamServiceProvider = Provider<TeamService>((ref) {
  throw UnimplementedError('TeamService provider not implemented');
});

final teamsProvider = StateNotifierProvider<TeamsNotifier, AsyncValue<List<TeamModel>>>((ref) {
  return TeamsNotifier(ref.watch(teamServiceProvider));
});

class TeamsNotifier extends StateNotifier<AsyncValue<List<TeamModel>>> {
  final TeamService _teamService;

  TeamsNotifier(this._teamService) : super(const AsyncValue.loading()) {
    loadTeams();
  }

  Future<void> loadTeams() async {
    state = const AsyncValue.loading();
    try {
      final teams = await _teamService.getTeams();
      state = AsyncValue.data(teams);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createTeam(String name) async {
    try {
      final newTeam = await _teamService.createTeam(name);
      state.whenData((teams) {
        state = AsyncValue.data([...teams, newTeam]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTeam(String id, String name) async {
    try {
      final updatedTeam = await _teamService.updateTeam(id, name);
      state.whenData((teams) {
        final index = teams.indexWhere((team) => team.id == id);
        if (index != -1) {
          final updatedTeams = List<TeamModel>.from(teams);
          updatedTeams[index] = updatedTeam;
          state = AsyncValue.data(updatedTeams);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTeam(String id) async {
    try {
      await _teamService.deleteTeam(id);
      state.whenData((teams) {
        state = AsyncValue.data(teams.where((team) => team.id != id).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPlayerToTeam(String teamId, String playerId) async {
    try {
      await _teamService.addPlayerToTeam(teamId, playerId);
      state.whenData((teams) {
        final index = teams.indexWhere((team) => team.id == teamId);
        if (index != -1) {
          final updatedTeams = List<TeamModel>.from(teams);
          final updatedTeam = teams[index].copyWith(
            playerIds: [...teams[index].playerIds, playerId],
          );
          updatedTeams[index] = updatedTeam;
          state = AsyncValue.data(updatedTeams);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removePlayerFromTeam(String teamId, String playerId) async {
    try {
      await _teamService.removePlayerFromTeam(teamId, playerId);
      state.whenData((teams) {
        final index = teams.indexWhere((team) => team.id == teamId);
        if (index != -1) {
          final updatedTeams = List<TeamModel>.from(teams);
          final updatedTeam = teams[index].copyWith(
            playerIds: teams[index].playerIds.where((id) => id != playerId).toList(),
          );
          updatedTeams[index] = updatedTeam;
          state = AsyncValue.data(updatedTeams);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 