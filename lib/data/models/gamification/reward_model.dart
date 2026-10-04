enum RewardType { xp, coins, item, title, avatarFrame, powerUp, badge }

enum Rarity { common, rare, epic, legendary }

class RewardModel {
  final String id;
  final RewardType type;
  final Map<String, String> name;
  final Map<String, String> description;
  final int value;
  final String? iconUrl;
  final Rarity rarity;

  RewardModel({
    required this.id,
    this.type = RewardType.xp,
    Map<String, String>? name,
    Map<String, String>? description,
    this.value = 0,
    this.iconUrl,
    this.rarity = Rarity.common,
  })  : name = name ?? {'ar': 'مكافأة', 'en': 'Reward'},
        description = description ??
            {'ar': 'مكافأة من اللعبة', 'en': 'In-game reward'};

  static Rarity _parseRarity(String value) {
    switch (value) {
      case 'rare':
        return Rarity.rare;
      case 'epic':
        return Rarity.epic;
      case 'legendary':
        return Rarity.legendary;
      default:
        return Rarity.common;
    }
  }

  static RewardType _parseType(String value) {
    switch (value) {
      case 'coins':
        return RewardType.coins;
      case 'item':
        return RewardType.item;
      case 'title':
        return RewardType.title;
      case 'avatarFrame':
        return RewardType.avatarFrame;
      case 'powerUp':
        return RewardType.powerUp;
      case 'badge':
        return RewardType.badge;
      default:
        return RewardType.xp;
    }
  }

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
        id: json['id'] as String? ?? '',
        type: _parseType(json['type'] as String? ?? 'xp'),
        name: (json['name'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        description: (json['description'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        value: json['value'] as int? ?? 0,
        iconUrl: json['iconUrl'] as String?,
        rarity: _parseRarity(json['rarity'] as String? ?? 'common'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'description': description,
        'value': value,
        'iconUrl': iconUrl,
        'rarity': rarity.name,
      };
}
