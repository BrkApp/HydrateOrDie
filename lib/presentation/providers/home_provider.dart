import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';
import 'package:hydrate_or_die/core/di/injection.dart';

/// State model for the Home Screen
class HomeState {
  final AvatarPersonality personality;
  final AvatarState state;
  final DateTime? lastDrinkTime;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.personality,
    required this.state,
    this.lastDrinkTime,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    AvatarPersonality? personality,
    AvatarState? state,
    DateTime? lastDrinkTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      personality: personality ?? this.personality,
      state: state ?? this.state,
      lastDrinkTime: lastDrinkTime ?? this.lastDrinkTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider for Home Screen state management
///
/// Manages avatar state with automatic refresh every 60 seconds (AC #5).
/// Provides reactive state updates when avatar state changes (AC #7).
class HomeNotifier extends StateNotifier<HomeState> {
  final UpdateAvatarStateUseCase _updateAvatarStateUseCase;
  final AvatarRepository _avatarRepository;
  Timer? _refreshTimer;

  HomeNotifier(
    this._updateAvatarStateUseCase,
    this._avatarRepository,
  ) : super(const HomeState(
          personality: AvatarPersonality.doctor, // Default
          state: AvatarState.fresh,
        )) {
    _init();
  }

  /// Initialize home state - loads current avatar and starts auto-refresh
  Future<void> _init() async {
    await refresh();
    _startAutoRefresh();
  }

  /// Refresh avatar state - fetches personality, state, and last drink time
  Future<void> refresh() async {
    try {
      // Force update avatar state based on elapsed time (AC #2)
      final newState = await _updateAvatarStateUseCase.execute();

      // Get current avatar (includes personality, state, lastDrinkTime) (AC #1, #4)
      final avatar = await _avatarRepository.getAvatar();

      state = state.copyWith(
        personality: avatar?.personality ?? AvatarPersonality.doctor, // Default if null
        state: newState,
        lastDrinkTime: avatar?.lastDrinkTime,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      print('[HomeProvider] Error refreshing state: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Start automatic refresh timer - triggers every 60 seconds (AC #5)
  void _startAutoRefresh() {
    _refreshTimer?.cancel(); // Cancel existing timer if any

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) async {
        print('[HomeProvider] Auto-refresh triggered (60s interval)');
        await refresh();
      },
    );

    print('[HomeProvider] Auto-refresh timer started (60s interval)');
  }

  /// Stop automatic refresh timer - called on dispose
  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    print('[HomeProvider] Auto-refresh timer stopped');
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    super.dispose();
  }
}

/// Riverpod provider for HomeNotifier
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final updateAvatarStateUseCase = getIt<UpdateAvatarStateUseCase>();
  final avatarRepository = getIt<AvatarRepository>();

  return HomeNotifier(
    updateAvatarStateUseCase,
    avatarRepository,
  );
});
