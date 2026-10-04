import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:game_show_app/data/models/question/question_model.dart';

class AIException implements Exception {
  final String message;
  final int? statusCode;
  AIException(this.message, {this.statusCode});

  @override
  String toString() => 'AIException: $message${statusCode != null ? ' (code: $statusCode)' : ''}';
}

class AIService {
  final Dio _dio;
  String? _apiKey;

  static const int _maxRetries = 3;
  static const Duration _initialBackoff = Duration(seconds: 1);
  static const double _backoffMultiplier = 2.0;

  List<Map<String, dynamic>>? _cachedFallbackQuestions;

  AIService() : _dio = Dio(BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ));

  void configure(String apiKey) {
    _apiKey = apiKey;
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
  }

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  Future<List<Map<String, String>>> generateQuestions(
    String type, String language, {
    int count = 10,
    String difficulty = 'medium',
  }) async {
    if (!isConfigured) return _getFallbackQuestions(type, count);
    return _withRetry(() => _generateFromAI(type, language, count, difficulty));
  }

  Future<QuestionModel> generateQuestion(String category, String difficulty) async {
    if (isConfigured) {
      try {
        final questions = await _withRetry(() => _generateFromAI(category, 'en', 1, difficulty));
        if (questions.isNotEmpty) {
          final q = questions.first;
          return QuestionModel(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
            type: category,
            text: q['question']!,
            answer: q['answer']!,
            difficulty: difficulty,
            points: _pointsForDifficulty(difficulty),
          );
        }
      } catch (_) {}
    }

    final fallback = await _loadFallbackQuestions();
    final pool = fallback.where((q) =>
        (q['type'] == category || q['type'] == 'general') &&
        q['difficulty'] == difficulty).toList();

    if (pool.isEmpty) {
      return QuestionModel(
        id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
        type: category,
        text: 'Sample $category question at $difficulty level?',
        answer: 'Sample answer',
        difficulty: difficulty,
        points: _pointsForDifficulty(difficulty),
      );
    }

    final q = pool[Random().nextInt(pool.length)];
    return QuestionModel(
      id: 'fallback_${q['id'] ?? DateTime.now().millisecondsSinceEpoch}',
      type: category,
      text: q['text'] as String,
      answer: q['answer'] as String?,
      difficulty: difficulty,
      points: _pointsForDifficulty(difficulty),
    );
  }

  double cheatDetection(String answer, String correctAnswer) {
    if (correctAnswer.isEmpty || answer.isEmpty) return 0.0;

    final normalizedAnswer = answer.trim().toLowerCase();
    final normalizedCorrect = correctAnswer.trim().toLowerCase();

    if (normalizedAnswer == normalizedCorrect) return 0.0;

    if (normalizedCorrect.contains(normalizedAnswer) || normalizedAnswer.contains(normalizedCorrect)) {
      return 0.3;
    }

    final answerWords = normalizedAnswer.split(RegExp(r'\s+'));
    final correctWords = normalizedCorrect.split(RegExp(r'\s+'));
    final commonWords = answerWords.where((w) => correctWords.contains(w)).length;
    final wordOverlap = correctWords.isEmpty ? 0.0 : commonWords / correctWords.length;

    if (wordOverlap > 0.8) return 0.5;
    if (wordOverlap > 0.5) return 0.2;

    return 0.0;
  }

  Future<bool> detectCheat(String playerId, String questionId, String answer, int responseTimeMs) async {
    if (!isConfigured) return false;
    final avgTime = _getAverageResponseTime(questionId);
    if (responseTimeMs < avgTime * 0.3 && avgTime > 3000) return true;
    if (responseTimeMs < 500) return true;
    return false;
  }

  Future<String> translateQuestion(String text, String targetLanguage) async {
    if (!isConfigured) return text;
    try {
      final response = await _dio.post('/chat/completions', data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': 'Translate to $targetLanguage. Return ONLY the translation.'},
          {'role': 'user', 'content': text},
        ],
        'temperature': 0.3,
      });
      return response.data['choices'][0]['message']['content'] as String;
    } catch (_) {
      return text;
    }
  }

  double calculateDifficulty(double playerWinRate, int streak, int gamesPlayed) {
    double difficulty = 0.5;
    difficulty += (playerWinRate - 0.5) * 0.3;
    difficulty += (streak / 10) * 0.2;
    return difficulty.clamp(0.1, 0.95);
  }

  double predictChurnRisk(int gamesPlayed, int daysSinceLastGame, double winRate) {
    double risk = 0;
    if (daysSinceLastGame > 7) risk += 0.3;
    if (daysSinceLastGame > 30) risk += 0.5;
    if (winRate < 0.2) risk += 0.2;
    if (gamesPlayed < 5) risk += 0.1;
    return risk.clamp(0, 1);
  }

  Future<List<Map<String, dynamic>>> _loadFallbackQuestions() async {
    if (_cachedFallbackQuestions != null) return _cachedFallbackQuestions!;

    try {
      final jsonStr = await rootBundle.loadString('assets/questions_general.json');
      final List<dynamic> parsed = jsonDecode(jsonStr);
      _cachedFallbackQuestions = parsed.map((item) => {
        'id': 'fb_${item['answer'] ?? Random().nextInt(99999)}',
        'type': 'general',
        'text': item['question'] as String,
        'answer': item['answer'] as String,
        'difficulty': 'medium',
      }).toList();
      return _cachedFallbackQuestions!;
    } catch (_) {
      return _staticFallback();
    }
  }

  List<Map<String, dynamic>> _staticFallback() {
    return const [
      {'id': 's1', 'type': 'general', 'text': 'What is the capital of Australia?', 'answer': 'Canberra', 'difficulty': 'medium'},
      {'id': 's2', 'type': 'general', 'text': 'What is the largest ocean on Earth?', 'answer': 'Pacific Ocean', 'difficulty': 'easy'},
      {'id': 's3', 'type': 'general', 'text': 'What is the longest river in the world?', 'answer': 'Nile', 'difficulty': 'easy'},
      {'id': 's4', 'type': 'general', 'text': 'On which continent are the Alps located?', 'answer': 'Europe', 'difficulty': 'easy'},
      {'id': 's5', 'type': 'general', 'text': 'What is the fastest land animal?', 'answer': 'Cheetah', 'difficulty': 'medium'},
      {'id': 's6', 'type': 'general', 'text': 'How many planets are in our solar system?', 'answer': '8', 'difficulty': 'easy'},
      {'id': 's7', 'type': 'general', 'text': 'What is the capital of Japan?', 'answer': 'Tokyo', 'difficulty': 'easy'},
      {'id': 's8', 'type': 'general', 'text': 'What is the largest organ in the human body?', 'answer': 'Skin', 'difficulty': 'medium'},
      {'id': 's9', 'type': 'general', 'text': 'What is the currency of the UK?', 'answer': 'Pound Sterling', 'difficulty': 'medium'},
      {'id': 's10', 'type': 'general', 'text': 'In which year did World War I begin?', 'answer': '1914', 'difficulty': 'hard'},
      {'id': 's11', 'type': 'general', 'text': 'What is the chemical symbol for water?', 'answer': 'H2O', 'difficulty': 'easy'},
      {'id': 's12', 'type': 'general', 'text': 'Who painted the Mona Lisa?', 'answer': 'Leonardo da Vinci', 'difficulty': 'easy'},
    ];
  }

  Future<List<Map<String, String>>> _generateFromAI(
    String type, String language, int count, String difficulty,
  ) async {
    final response = await _dio.post('/chat/completions', data: {
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a quiz question generator. Generate $count $difficulty questions about $type in $language. Return JSON array with "question" and "answer" fields.',
        },
        {'role': 'user', 'content': 'Generate $count unique $type questions in $language'},
      ],
      'temperature': 0.8,
      'max_tokens': 2000,
    });
    final content = response.data['choices'][0]['message']['content'];
    final cleaned = content.replaceAll('```json', '').replaceAll('```', '').trim();
    final List<dynamic> questions = jsonDecode(cleaned);
    return questions
        .map((q) => { 'question': q['question'] as String, 'answer': q['answer'] as String })
        .toList();
  }

  Future<T> _withRetry<T>(Future<T> Function() fn) async {
    var backoff = _initialBackoff;
    for (int i = 0; i < _maxRetries; i++) {
      try {
        return await fn();
      } on DioException catch (e) {
        if (i == _maxRetries - 1) {
          throw AIException(
            e.message ?? 'API request failed',
            statusCode: e.response?.statusCode,
          );
        }
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode < 500 && statusCode != 429) {
          rethrow;
        }
        await Future.delayed(backoff);
        backoff = Duration(milliseconds: (backoff.inMilliseconds * _backoffMultiplier).toInt());
      } catch (e) {
        if (i == _maxRetries - 1) rethrow;
        await Future.delayed(backoff);
        backoff = Duration(milliseconds: (backoff.inMilliseconds * _backoffMultiplier).toInt());
      }
    }
    throw AIException('Max retries exceeded');
  }

  List<Map<String, String>> _getFallbackQuestions(String type, int count) {
    return List.generate(count, (i) => {
      'question': 'Question $type #${i + 1}: What is the correct answer?',
      'answer': 'This is answer #${i + 1}',
    });
  }

  int _getAverageResponseTime(String questionId) => 5000;

  int _pointsForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy': return 100;
      case 'medium': return 250;
      case 'hard': return 500;
      default: return 100;
    }
  }
}

final aiService = AIService();
