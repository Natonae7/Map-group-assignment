import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../services/api/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  throw UnimplementedError('UserService provider not implemented');
});

final currentUserIdProvider = Provider<String>((ref) {
  return 'abc123'; // Replace this with logic to get logged-in user ID
});

final userProvider = Provider<AsyncValue<UserModel?>>((ref) {
  final usersAsync = ref.watch(usersProvider);
  final userId = ref.watch(currentUserIdProvider);


  return usersAsync.when(
    data: (users) {
      final user = users.where((u) => u.id == userId).toList();
      if (user.isNotEmpty) {
        return AsyncValue.data(user.first);
      } else {
        return const AsyncValue.data(null); // ✅ safely return nullable
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
final usersProvider = StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
  (ref) => UsersNotifier(ref.watch(userServiceProvider)),
);

class UsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserService _userService;

  UsersNotifier(this._userService) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _userService.getUsers();
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUser(
    String id,
    String fullName,
    String email,
    String role,
  ) async {
    try {
      final updatedUser = await _userService.updateUser(
        id,
        fullName,
        email,
        role,
      );
      state.whenData((users) {
        final index = users.indexWhere((user) => user.id == id);
        if (index != -1) {
          final updatedUsers = List<UserModel>.from(users);
          updatedUsers[index] = updatedUser;
          state = AsyncValue.data(updatedUsers);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userService.deleteUser(id);
      state.whenData((users) {
        state = AsyncValue.data(users.where((user) => user.id != id).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> assignTeamToUser(String userId, String teamId) async {
    try {
      await _userService.assignTeamToUser(userId, teamId);
      state.whenData((users) {
        final index = users.indexWhere((user) => user.id == userId);
        if (index != -1) {
          final updatedUsers = List<UserModel>.from(users);
          final updatedUser = users[index].copyWith(teamId: teamId);
          updatedUsers[index] = updatedUser;
          state = AsyncValue.data(updatedUsers);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeTeamFromUser(String userId) async {
    try {
      await _userService.removeTeamFromUser(userId);
      state.whenData((users) {
        final index = users.indexWhere((user) => user.id == userId);
        if (index != -1) {
          final updatedUsers = List<UserModel>.from(users);
          final updatedUser = users[index].copyWith(teamId: null);
          updatedUsers[index] = updatedUser;
          state = AsyncValue.data(updatedUsers);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 