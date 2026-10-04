import 'package:game_show_app/data/models/game/player_model.dart';

class CalculateScores {
  List<PlayerModel> call(List<PlayerModel> players) {
    final sorted = List<PlayerModel>.from(players)
      ..sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }
}
