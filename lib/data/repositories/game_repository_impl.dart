import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:game_show_app/core/infrastructure/cache_manager.dart';
import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

class GameRepositoryImpl implements GameRepository {
  final FirestoreService _firestoreService;
  final CacheManager _cacheManager;

  GameRepositoryImpl(this._firestoreService, this._cacheManager);

  @override
  Future<List<QuestionModel>> getQuestions(String type,
      {String? difficulty, int limit = 50}) async {
    final cacheKey = 'questions_${type}_${difficulty ?? 'all'}';

    final cached = _cacheManager.get<List<QuestionModel>>(cacheKey);
    if (cached != null) {
      AppLogger.debug('Cache hit for questions: $cacheKey');
      return cached;
    }

    try {
      final docs = await _firestoreService.getQuestions(
        type: type,
        limit: limit,
        difficulty: difficulty,
      );
      if (docs.isNotEmpty) {
        final questions = docs
            .map((doc) =>
                QuestionModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        _cacheManager.set<List<QuestionModel>>(cacheKey, questions);
        return questions;
      }
    } catch (e) {
      AppLogger.error('Failed to fetch questions from Firestore', e);
    }

    final local = await _loadLocalQuestions(type);
    if (local.isNotEmpty) {
      _cacheManager.set<List<QuestionModel>>(cacheKey, local);
    }
    return local;
  }

  Future<List<QuestionModel>> _loadLocalQuestions(String type) async {
    final assetPath = _getAssetPath(type);
    if (assetPath == null) return [];

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      if (type == 'words') {
        final List<dynamic> wordsList = jsonDecode(jsonString);
        return wordsList.map((word) {
          return QuestionModel(
            id: 'w_${word.hashCode}',
            type: type,
            text: word.toString(),
            answer: word.toString(),
          );
        }).toList();
      } else {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map<QuestionModel>((json) {
          return QuestionModel(
            id: '${type}_${json['question']?.hashCode ?? DateTime.now().millisecondsSinceEpoch}',
            type: type,
            text: json['question'] as String? ?? '',
            answer: json['answer'] as String? ?? '',
          );
        }).toList();
      }
    } catch (e) {
      return [];
    }
  }

  String? _getAssetPath(String type) {
    switch (type) {
      case 'trivia':
        return 'assets/questions_general.json';
      case 'movies':
        return 'assets/movies_series.json';
      case 'music':
        return null;
      case 'puzzles':
        return 'assets/puzzle.json';
      case 'words':
        return 'assets/words_list.json';
      default:
        return null;
    }
  }

  @override
  Future<String> createSession(GameSessionModel session) async {
    return await _firestoreService.createGameSession(session.toJson());
  }

  @override
  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    await _firestoreService.updateGameSession(id, data);
  }

  @override
  Stream<GameSessionModel?> sessionStream(String id) {
    return _firestoreService.gameSessionStream(id).map((doc) {
      if (!doc.exists) return null;
      return GameSessionModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<void> submitAnswer(String sessionId, String playerId,
      String questionId, String answer) async {
    await _firestoreService.updateGameSession(sessionId, {
      'answers.$playerId': {
        'questionId': questionId,
        'answer': answer,
        'timestamp': FieldValue.serverTimestamp(),
      },
    });
  }

  @override
  Future<List<PlayerModel>> getSessionPlayers(String sessionId) async {
    try {
      final doc = await _firestoreService.getGameSession(sessionId);
      if (!doc.exists) return [];
      final data = doc.data() as Map<String, dynamic>;
      final playersList = data['players'] as List<dynamic>?;
      if (playersList == null) return [];
      return playersList.map((p) => PlayerModel.fromJson(p as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
