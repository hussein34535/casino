import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  final FirebaseFirestore _db;

  SeedService(this._db);

  Future<SeedResult> seedAllQuestions() async {
    int total = 0;
    final errors = <String>[];

    final sources = [
      _SeedSource('trivia', 'assets/questions_general.json', _parseQaJson),
      _SeedSource('movies', 'assets/movies_series.json', _parseQaJson),
      _SeedSource('puzzles', 'assets/puzzle.json', _parseQaJson),
      _SeedSource('words', 'assets/words_list.json', _parseWordListJson),
    ];

    for (final source in sources) {
      try {
        final jsonStr = await rootBundle.loadString(source.assetPath);
        final items = source.parser(jsonStr);
        final count = await _batchWrite(source.type, items);
        total += count;
      } catch (e) {
        errors.add('${source.type}: $e');
      }
    }

    return SeedResult(totalQuestions: total, errors: errors);
  }

  List<Map<String, dynamic>> _parseQaJson(String jsonStr) {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => {
      'text': e['question'] as String? ?? '',
      'answer': e['answer'] as String? ?? '',
    }).toList();
  }

  List<Map<String, dynamic>> _parseWordListJson(String jsonStr) {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => {
      'text': e.toString(),
      'answer': e.toString(),
    }).toList();
  }

  Future<int> _batchWrite(String type, List<Map<String, dynamic>> items) async {
    final difficulties = ['easy', 'medium', 'hard'];
    final chunkSize = 400;
    int written = 0;

    for (var i = 0; i < items.length; i += chunkSize) {
      final end = (i + chunkSize > items.length) ? items.length : i + chunkSize;
      final batch = _db.batch();

      for (var j = i; j < end; j++) {
        final item = items[j];
        final difficulty = difficulties[(j ~/ (items.length / 3).ceil()).clamp(0, 2)];

        final docRef = _db.collection('questions').doc();
        batch.set(docRef, {
          'id': docRef.id,
          'type': type,
          'text': item['text'],
          'answer': item['answer'],
          'difficulty': difficulty,
          'isActive': true,
          'isApproved': true,
          'timesUsed': 0,
          'reportCount': 0,
          'points': difficulty == 'hard' ? 3 : (difficulty == 'medium' ? 2 : 1),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      written += (end - i);
    }

    return written;
  }
}

class _SeedSource {
  final String type;
  final String assetPath;
  final List<Map<String, dynamic>> Function(String) parser;
  _SeedSource(this.type, this.assetPath, this.parser);
}

class SeedResult {
  final int totalQuestions;
  final List<String> errors;
  bool get hasErrors => errors.isNotEmpty;

  SeedResult({required this.totalQuestions, required this.errors});
}
