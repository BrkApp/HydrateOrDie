import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';

/// Provider to fetch today's hydration logs.
///
/// This provider fetches hydration logs from the repository for the current day
/// and makes them available to the UI for displaying progress, history, and
/// calculating today's hydration volume.
///
/// The provider automatically refreshes when invalidated (e.g., after recording
/// a new hydration entry).
final hydrationLogsProvider = FutureProvider<List<HydrationLog>>((ref) async {
  final repository = getIt<HydrationLogRepository>();
  return repository.getTodayLogs();
});
