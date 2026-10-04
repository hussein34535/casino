import 'package:cloud_firestore/cloud_firestore.dart';

enum ChallengeType { daily, weekly, monthly }
enum ChallengePeriod { daily, weekly, monthly }

class DailyChallengeModel {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final int xpReward;
  final int coinReward;
  int progress;
  int requiredProgress;
  int requiredAmount;
  bool isCompleted;
  bool rewardClaimed;
  DateTime? expiresAt;
  ChallengeType type;
  ChallengePeriod period;
  String iconName;

  double get progressFraction => requiredAmount > 0 ? progress / requiredAmount : 0.0;

  DailyChallengeModel({
    required this.id,
    Map<String, String>? title,
    Map<String, String>? description,
    this.xpReward = 0,
    this.coinReward = 0,
    this.progress = 0,
    this.requiredProgress = 1,
    this.requiredAmount = 1,
    this.isCompleted = false,
    this.rewardClaimed = false,
    this.expiresAt,
    this.type = ChallengeType.daily,
    this.period = ChallengePeriod.daily,
    this.iconName = '',
  })  : title = title ?? {'ar': 'تحدي جديد', 'en': 'New Challenge'},
        description = description ??
            {'ar': 'أكمل التحدي لتحصل على المكافأة',
             'en': 'Complete the challenge to earn rewards'};

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static ChallengeType _parseType(String value) {
    switch (value) {
      case 'weekly':
        return ChallengeType.weekly;
      case 'monthly':
        return ChallengeType.monthly;
      default:
        return ChallengeType.daily;
    }
  }

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) =>
      DailyChallengeModel(
        id: json['id'] as String? ?? '',
        title: (json['title'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        description: (json['description'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        xpReward: json['xpReward'] as int? ?? 0,
        coinReward: json['coinReward'] as int? ?? 0,
        progress: json['progress'] as int? ?? 0,
        requiredProgress: json['requiredProgress'] as int? ?? 1,
        requiredAmount: json['requiredAmount'] as int? ?? 1,
        isCompleted: json['isCompleted'] as bool? ?? false,
        rewardClaimed: json['rewardClaimed'] as bool? ?? false,
        expiresAt: _parseDate(json['expiresAt']),
        type: _parseType(json['type'] as String? ?? 'daily'),
        period: ChallengePeriod.values.firstWhere(
          (e) => e.name == json['period'],
          orElse: () => ChallengePeriod.daily,
        ),
        iconName: json['iconName'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'xpReward': xpReward,
        'coinReward': coinReward,
        'progress': progress,
        'requiredProgress': requiredProgress,
        'requiredAmount': requiredAmount,
        'isCompleted': isCompleted,
        'rewardClaimed': rewardClaimed,
        'expiresAt': expiresAt,
        'type': type.name,
        'period': period.name,
        'iconName': iconName,
      };
}
