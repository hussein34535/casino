import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementModel {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int requiredProgress;
  final int xpReward;
  final int coinReward;
  final bool isHidden;
  final String? category;

  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconName = 'trophy',
    this.requiredProgress = 0,
    this.xpReward = 0,
    this.coinReward = 0,
    this.isHidden = false,
    this.category,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) => AchievementModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    iconName: json['iconName'] as String? ?? 'trophy',
    requiredProgress: json['requiredProgress'] as int? ?? 0,
    xpReward: json['xpReward'] as int? ?? 0,
    coinReward: json['coinReward'] as int? ?? 0,
    isHidden: json['isHidden'] as bool? ?? false,
    category: json['category'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'iconName': iconName,
    'requiredProgress': requiredProgress,
    'xpReward': xpReward,
    'coinReward': coinReward,
    'isHidden': isHidden,
    'category': category,
  };
}

class UserAchievement {
  final String id;
  final String achievementId;
  final String userId;
  int progress;
  bool isUnlocked;
  DateTime? unlockedAt;
  bool rewardClaimed;

  UserAchievement({
    required this.id,
    required this.achievementId,
    required this.userId,
    this.progress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rewardClaimed = false,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return UserAchievement(
      id: json['id'] as String? ?? '',
      achievementId: json['achievementId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      progress: json['progress'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: parseDate(json['unlockedAt']),
      rewardClaimed: json['rewardClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'achievementId': achievementId,
    'userId': userId,
    'progress': progress,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt,
    'rewardClaimed': rewardClaimed,
  };
}
