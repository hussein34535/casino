enum LevelRewardType { xp, coins, item, title, badge }

class LevelRewardModel {
  final int level;
  final String description;
  final LevelRewardType type;
  final int amount;
  final String? itemId;

  const LevelRewardModel({
    required this.level,
    required this.description,
    this.type = LevelRewardType.coins,
    this.amount = 0,
    this.itemId,
  });

  factory LevelRewardModel.fromJson(Map<String, dynamic> json) =>
      LevelRewardModel(
        level: json['level'] as int? ?? 1,
        description: json['description'] as String? ?? '',
        type: LevelRewardType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LevelRewardType.coins,
        ),
        amount: json['amount'] as int? ?? 0,
        itemId: json['itemId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'description': description,
        'type': type.name,
        'amount': amount,
        'itemId': itemId,
      };
}
