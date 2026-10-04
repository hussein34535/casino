import 'package:game_show_app/features/power_ups.dart';

class GetPowerUps {
  List<PowerUp> call() {
    return PowerUpType.values.map((e) => PowerUp(type: e)).toList();
  }
}
