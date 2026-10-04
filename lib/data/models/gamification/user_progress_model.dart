import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgressModel {
  final String userId;
  int totalXp;
  int level;
  int coins;
  int gems;
  int streak;
  DateTime? lastActiveDate;
  String? battlePassId;
  int battlePassLevel;
  int battlePassXp;
  List<String> completedChallenges;
  List<String> ownedItems;
  String? equippedTitle;
  String? equippedAvatarFrame;

  UserProgressModel({
    required this.userId,
    this.totalXp = 0,
    this.level = 1,
    this.coins = 0,
    this.gems = 0,
    this.streak = 0,
    this.lastActiveDate,
    this.battlePassId,
    this.battlePassLevel = 1,
    this.battlePassXp = 0,
    this.completedChallenges = const [],
    this.ownedItems = const [],
    this.equippedTitle,
    this.equippedAvatarFrame,
  });

  int get xp => totalXp;
  set xp(int value) { totalXp = value; }
  int get xpForNextLevel => level * 100;
  int get xpProgress => totalXp % xpForNextLevel;

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      UserProgressModel(
        userId: json['userId'] as String? ?? '',
        totalXp: json['totalXp'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        coins: json['coins'] as int? ?? 0,
        gems: json['gems'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
        lastActiveDate: _parseDate(json['lastActiveDate']),
        battlePassId: json['battlePassId'] as String?,
        battlePassLevel: json['battlePassLevel'] as int? ?? 1,
        battlePassXp: json['battlePassXp'] as int? ?? 0,
        completedChallenges:
            (json['completedChallenges'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
        ownedItems: (json['ownedItems'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        equippedTitle: json['equippedTitle'] as String?,
        equippedAvatarFrame: json['equippedAvatarFrame'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'totalXp': totalXp,
        'level': level,
        'coins': coins,
        'gems': gems,
        'streak': streak,
        'lastActiveDate': lastActiveDate,
        'battlePassId': battlePassId,
        'battlePassLevel': battlePassLevel,
        'battlePassXp': battlePassXp,
        'completedChallenges': completedChallenges,
        'ownedItems': ownedItems,
        'equippedTitle': equippedTitle,
        'equippedAvatarFrame': equippedAvatarFrame,
      };
}
