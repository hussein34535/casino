import 'package:flutter/material.dart';

class QuestionModel {
  final String id;
  final String type;
  final String text;
  final String? answer;
  final String? audioUrl;
  final String? singerName;
  final String? songName;
  final String? imageUrl;
  final String? category;
  final String difficulty;
  final bool isActive;
  final int timesUsed;
  final String? createdBy;
  final int reportCount;
  final bool isApproved;
  final int points;

  QuestionModel({
    required this.id,
    required this.type,
    required this.text,
    this.answer,
    this.audioUrl,
    this.singerName,
    this.songName,
    this.imageUrl,
    this.category,
    this.difficulty = 'easy',
    this.isActive = true,
    this.timesUsed = 0,
    this.createdBy,
    this.reportCount = 0,
    this.isApproved = true,
    this.points = 0,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: json['id'] as String? ?? '',
    type: json['type'] as String? ?? '',
    text: json['text'] as String? ?? '',
    answer: json['answer'] as String?,
    audioUrl: json['audioUrl'] as String?,
    singerName: json['singerName'] as String?,
    songName: json['songName'] as String?,
    imageUrl: json['imageUrl'] as String?,
    category: json['category'] as String?,
    difficulty: json['difficulty'] as String? ?? 'easy',
    isActive: json['isActive'] as bool? ?? true,
    timesUsed: json['timesUsed'] as int? ?? 0,
    createdBy: json['createdBy'] as String?,
    reportCount: json['reportCount'] as int? ?? 0,
    isApproved: json['isApproved'] as bool? ?? true,
    points: json['points'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'text': text,
    'answer': answer,
    'audioUrl': audioUrl,
    'singerName': singerName,
    'songName': songName,
    'imageUrl': imageUrl,
    'category': category,
    'difficulty': difficulty,
    'isActive': isActive,
    'timesUsed': timesUsed,
    'createdBy': createdBy,
    'reportCount': reportCount,
    'isApproved': isApproved,
    'points': points,
  };

  static const Map<String, List<Color>> typeGradients = {
    'trivia': [Color(0xFF1A237E), Color(0xFF3F51B5)],
    'movies': [Color(0xFF4A148C), Color(0xFF7B1FA2)],
    'music': [Color(0xFF004D40), Color(0xFF00796B)],
    'puzzles': [Color(0xFFBF360C), Color(0xFFF4511E)],
    'words': [Color(0xFFFF6F00), Color(0xFFFFB300)],
  };
}
