import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/user_repository.dart';

/// Provider for User entity
///
/// Provides access to the current user profile.
/// Returns null if no user has been created yet.
final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  () => UserNotifier(),
);

/// Notifier for User state management
///
/// Manages the user profile state and provides methods to reload user data.
class UserNotifier extends AsyncNotifier<User?> {
  late final UserRepository _userRepository;

  @override
  Future<User?> build() async {
    _userRepository = getIt<UserRepository>();
    return await _userRepository.getProfile();
  }

  /// Reload user data from repository
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _userRepository.getProfile());
  }
}
