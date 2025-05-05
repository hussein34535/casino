import 'package:flutter/foundation.dart';

class Player {
  final String name;
  int score;
  int yellowCards;
  int redCards;

  Player({
    required this.name,
    this.score = 0,
    this.yellowCards = 0,
    this.redCards = 0,
  });

  // يمكن إضافة دوال أخرى هنا لاحقًا إذا لزم الأمر
}
