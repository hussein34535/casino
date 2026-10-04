import 'package:cloud_firestore/cloud_firestore.dart';

class StreakModel {
  final String userId;
  int currentStreak;
  int longestStreak;
  DateTime? lastActiveDate;
  List<int> claimedRewards;

  StreakModel({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    List<int>? claimedRewards,
  }) : claimedRewards = claimedRewards ?? [];

  bool get isActive =>
      lastActiveDate != null &&
      DateTime.now().difference(lastActiveDate!).inDays <= 1;

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  factory StreakModel.fromJson(Map<String, dynamic> json) => StreakModel(
        userId: json['userId'] as String? ?? '',
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        lastActiveDate: _parseDate(json['lastActiveDate']),
        claimedRewards: (json['claimedRewards'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActiveDate': lastActiveDate,
        'claimedRewards': claimedRewards,
      };
}
