import 'dart:math';

class AIOpponent {
  final String name;
  final String difficulty; // 'easy', 'medium', 'hard', 'elon'
  final double accuracyRate;
  final double responseTimeMs;

  AIOpponent({
    required this.name,
    required this.difficulty,
    this.accuracyRate = 0.5,
    this.responseTimeMs = 3000,
  });

  static final List<AIOpponent> opponents = [
    AIOpponent(name: 'AI Novice', difficulty: 'easy', accuracyRate: 0.3, responseTimeMs: 5000),
    AIOpponent(name: 'AI Scholar', difficulty: 'medium', accuracyRate: 0.6, responseTimeMs: 3000),
    AIOpponent(name: 'AI Genius', difficulty: 'hard', accuracyRate: 0.85, responseTimeMs: 1500),
    AIOpponent(name: 'Elon Mode', difficulty: 'elon', accuracyRate: 0.95, responseTimeMs: 500),
  ];

  bool answerQuestion(String questionDifficulty) {
    final random = Random();
    double baseAccuracy = accuracyRate;
    if (questionDifficulty == 'easy') baseAccuracy += 0.1;
    if (questionDifficulty == 'hard') baseAccuracy -= 0.15;
    return random.nextDouble() < baseAccuracy.clamp(0, 1);
  }

  Duration getResponseTime() {
    final random = Random();
    final variance = responseTimeMs * 0.2;
    return Duration(milliseconds: (responseTimeMs + random.nextDouble() * variance).toInt());
  }

  String getTaunt() {
    final taunts = {
      'easy': ['Easy peasy!', 'Is that your best?', 'Come on!'],
      'medium': ['Not bad...', 'Getting interesting!', 'You\'re good!'],
      'hard': ['Impressive!', 'A worthy opponent!', 'Finally a challenge!'],
      'elon': ['Let that sink in!', 'Amazing!', 'My Boring Company > your knowledge'],
    };
    final random = Random();
    final pool = taunts[difficulty] ?? taunts['medium']!;
    return pool[random.nextInt(pool.length)];
  }
}
