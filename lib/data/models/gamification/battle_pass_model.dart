import 'package:cloud_firestore/cloud_firestore.dart';

class BattlePassModel {
  final String id;
  final String seasonId;
  final String userId;
  int level;
  int xp;
  bool isPremium;
  int startLevel;
  int maxLevel;
  final Map<String, String> name;
  DateTime? startedAt;
  DateTime? claimedAt;
  List<String> rewards;

  BattlePassModel({
    required this.id,
    required this.seasonId,
    required this.userId,
    this.level = 1,
    this.xp = 0,
    this.isPremium = false,
    this.startLevel = 1,
    this.maxLevel = 50,
    Map<String, String>? name,
    this.startedAt,
    this.claimedAt,
    this.rewards = const [],
  }) : name = name ?? {'ar': 'موسم', 'en': 'Season'};

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  factory BattlePassModel.fromJson(Map<String, dynamic> json) =>
      BattlePassModel(
        id: json['id'] as String? ?? '',
        seasonId: json['seasonId'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        level: json['level'] as int? ?? 1,
        xp: json['xp'] as int? ?? 0,
        isPremium: json['isPremium'] as bool? ?? false,
        startLevel: json['startLevel'] as int? ?? 1,
        maxLevel: json['maxLevel'] as int? ?? 50,
        name: (json['name'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        startedAt: _parseDate(json['startedAt']),
        claimedAt: _parseDate(json['claimedAt']),
        rewards: (json['rewards'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'seasonId': seasonId,
        'userId': userId,
        'level': level,
        'xp': xp,
        'isPremium': isPremium,
        'startLevel': startLevel,
        'maxLevel': maxLevel,
        'name': name,
        'startedAt': startedAt,
        'claimedAt': claimedAt,
        'rewards': rewards,
      };
}
