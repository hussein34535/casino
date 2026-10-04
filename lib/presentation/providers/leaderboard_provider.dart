import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/presentation/providers/user_provider.dart';

final leaderboardProvider = FutureProvider.family<List<LeaderboardEntry>, String>((ref, period) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getLeaderboard(period: period);
});
