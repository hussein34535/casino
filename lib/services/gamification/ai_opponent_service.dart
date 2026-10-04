import 'dart:math';
import 'package:game_show_app/data/models/question/question_model.dart';

class AIOpponentService {
  final String name;
  final String difficulty;
  final Random _random = Random();

  int _correctCount = 0;
  int _totalCount = 0;
  int _score = 0;

  AIOpponentService({
    required this.name,
    required this.difficulty,
  });

  double get accuracyRate {
    switch (difficulty) {
      case 'easy':
        return 0.5;
      case 'medium':
        return 0.7;
      case 'hard':
        return 0.85;
      case 'elon':
        return 0.95;
      default:
        return 0.5;
    }
  }

  bool answerQuestion(QuestionModel question) {
    _totalCount++;
    double accuracy = accuracyRate;
    if (question.difficulty == 'easy') accuracy += 0.1;
    if (question.difficulty == 'hard') accuracy -= 0.15;
    final correct = _random.nextDouble() < accuracy.clamp(0, 1);
    if (correct) {
      _correctCount++;
      _score += question.points;
    }
    return correct;
  }

  Duration getResponseTime() {
    final baseMs = switch (difficulty) {
      'easy' => 5000,
      'medium' => 3000,
      'hard' => 1500,
      'elon' => 500,
      _ => 3000,
    };
    final variance = baseMs * 0.3;
    return Duration(
      milliseconds: (baseMs + _random.nextDouble() * variance).toInt(),
    );
  }

  String? getTaunt(int playerScore) {
    if (_totalCount == 0 || _totalCount % 3 != 0 || _random.nextDouble() >= 0.5) {
      return null;
    }

    final diff = _score - playerScore;
    final state = diff > 5 ? 'leading' : (diff < -5 ? 'trailing' : 'close');

    switch (difficulty) {
      case 'easy':
        return _randomTaunt({
          'leading': ['Easy peasy!', 'Is that your best?', 'Too slow!'],
          'trailing': ['Lucky guess!', "Beginner's luck!", 'I let you have that one!'],
          'close': ['Not bad...', 'Interesting!', 'Keep trying!'],
        }, state);
      case 'medium':
        return _randomTaunt({
          'leading': ["I'm on fire!", 'Can you keep up?', 'Nice try!'],
          'trailing': ['Alright, you got me!', 'Impressive!', 'Lucky streak!'],
          'close': ['Close game!', "You're good!", 'This is fun!'],
        }, state);
      case 'hard':
        return _randomTaunt({
          'leading': ["You'll have to do better!", 'Is that all?', 'Predictable!'],
          'trailing': ['Well played!', 'You earned that!', 'Finally!'],
          'close': ['Impressive!', 'A worthy opponent!', 'Great match!'],
        }, state);
      case 'elon':
        return _randomTaunt({
          'leading': ['Let that sink in!', 'Obviously!', 'My Boring Company > your knowledge'],
          'trailing': ['I was distracted by Mars!', "You're hired!", 'Okay, that was good!'],
          'close': ['Fascinating!', 'Neuralink would help!', "I'm impressed!"],
        }, state);
      default:
        return null;
    }
  }

  String? _randomTaunt(Map<String, List<String>> taunts, String state) {
    final pool = taunts[state] ?? taunts['close']!;
    return pool[_random.nextInt(pool.length)];
  }

  double getAccuracy() => _totalCount > 0 ? _correctCount / _totalCount : 0;

  int get score => _score;

  int get answeredCount => _totalCount;

  int get correctCount => _correctCount;

  void reset() {
    _correctCount = 0;
    _totalCount = 0;
    _score = 0;
  }
}
