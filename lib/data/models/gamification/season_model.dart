import 'package:cloud_firestore/cloud_firestore.dart';

class SeasonReward {
  final int level;
  final Map<String, String> description;
  final int xpReward;
  final int coinReward;
  final String? itemId;
  final bool isPremium;

  SeasonReward({
    required this.level,
    Map<String, String>? description,
    this.xpReward = 0,
    this.coinReward = 0,
    this.itemId,
    this.isPremium = false,
  }) : description = description ??
            {'ar': 'مكافأة المستوى $level', 'en': 'Level $level reward'};

  factory SeasonReward.fromJson(Map<String, dynamic> json) => SeasonReward(
        level: json['level'] as int? ?? 0,
        description: (json['description'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        xpReward: json['xpReward'] as int? ?? 0,
        coinReward: json['coinReward'] as int? ?? 0,
        itemId: json['itemId'] as String?,
        isPremium: json['isPremium'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'description': description,
        'xpReward': xpReward,
        'coinReward': coinReward,
        'itemId': itemId,
        'isPremium': isPremium,
      };
}

class SeasonModel {
  final String id;
  final Map<String, String> name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int battlePassPrice;
  final List<SeasonReward> rewards;

  SeasonModel({
    required this.id,
    Map<String, String>? name,
    required this.startDate,
    required this.endDate,
    this.isActive = false,
    this.battlePassPrice = 0,
    this.rewards = const [],
  }) : name = name ?? {'ar': 'موسم جديد', 'en': 'New Season'};

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json['id'] as String? ?? '',
        name: (json['name'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        startDate: _parseDate(json['startDate']) ?? DateTime.now(),
        endDate: _parseDate(json['endDate']) ?? DateTime.now(),
        isActive: json['isActive'] as bool? ?? false,
        battlePassPrice: json['battlePassPrice'] as int? ?? 0,
        rewards: (json['rewards'] as List<dynamic>?)
                ?.map((e) =>
                    SeasonReward.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate,
        'endDate': endDate,
        'isActive': isActive,
        'battlePassPrice': battlePassPrice,
        'rewards': rewards.map((r) => r.toJson()).toList(),
      };
}
