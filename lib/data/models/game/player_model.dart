class PlayerModel {
  final String id;
  final String name;
  int score;
  int yellowCards;
  int redCards;
  String? userId;
  bool isOnline;
  String? avatarUrl;
  String? photoUrl;
  bool isHost;

  PlayerModel({
    required this.id,
    required this.name,
    this.score = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.userId,
    this.isOnline = false,
    this.avatarUrl,
    this.photoUrl,
    this.isHost = false,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    score: json['score'] as int? ?? 0,
    yellowCards: json['yellowCards'] as int? ?? 0,
    redCards: json['redCards'] as int? ?? 0,
    userId: json['userId'] as String?,
    isOnline: json['isOnline'] as bool? ?? false,
    avatarUrl: json['avatarUrl'] as String?,
    photoUrl: json['photoUrl'] as String?,
    isHost: json['isHost'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'score': score,
    'yellowCards': yellowCards,
    'redCards': redCards,
    'userId': userId,
    'isOnline': isOnline,
    'avatarUrl': avatarUrl,
    'photoUrl': photoUrl,
    'isHost': isHost,
  };
}

class LocalPlayer {
  final String name;
  int score;
  int yellowCards;
  int redCards;
  final bool isBot;
  final String? botDifficulty;

  LocalPlayer({
    required this.name,
    this.score = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.isBot = false,
    this.botDifficulty,
  });
}
