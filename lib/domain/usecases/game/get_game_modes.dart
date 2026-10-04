import 'package:game_show_app/features/game_modes.dart';

class GetGameModes {
  List<GameMode> call() {
    return GameMode.values.toList();
  }
}
