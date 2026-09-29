import 'package:flutter/material.dart';

/// Single source of truth for game categories (replaces the emoji maps
/// that were duplicated across setup screens).
///
/// [icon] is a bundled Lucide SVG asset name (see [XoIcon]).
class GameCategory {
  final String id;
  final String titleAr;
  final String icon;
  final Color color;

  const GameCategory({
    required this.id,
    required this.titleAr,
    required this.icon,
    required this.color,
  });
}

const List<GameCategory> gameCategories = [
  GameCategory(id: 'trivia', titleAr: 'ثقافة عامة', icon: 'brain', color: Color(0xFF5B5FE9)),
  GameCategory(id: 'movies', titleAr: 'أفلام ومسلسلات', icon: 'film', color: Color(0xFFEC4899)),
  GameCategory(id: 'music', titleAr: 'موسيقى', icon: 'music', color: Color(0xFF8B5CF6)),
  GameCategory(id: 'puzzles', titleAr: 'ألغاز', icon: 'puzzle', color: Color(0xFFF59E0B)),
  GameCategory(id: 'words', titleAr: 'كلمات', icon: 'type', color: Color(0xFF10B981)),
];

