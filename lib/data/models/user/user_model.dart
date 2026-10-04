import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  String language;
  int xp;
  int level;
  int gamesPlayed;
  int gamesWon;
  int totalScore;
  int streak;
  int coins;
  bool isPremium;
  bool isAdmin;
  bool isBanned;
  bool emailVerified;
  DateTime? lastActiveAt;
  DateTime createdAt;
  List<String> friends;
  List<String> blockedUsers;
  Map<String, dynamic> settings;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.language = 'ar',
    this.xp = 0,
    this.level = 1,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalScore = 0,
    this.streak = 0,
    this.coins = 0,
    this.isPremium = false,
    this.isAdmin = false,
    this.isBanned = false,
    this.emailVerified = false,
    this.lastActiveAt,
    DateTime? createdAt,
    List<String>? friends,
    List<String>? blockedUsers,
    Map<String, dynamic>? settings,
  }) : createdAt = createdAt ?? DateTime.now(),
       friends = friends ?? [],
       blockedUsers = blockedUsers ?? [],
       settings = settings ?? {};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      language: json['language'] as String? ?? 'ar',
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      gamesWon: json['gamesWon'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isBanned: json['isBanned'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      lastActiveAt: parseDate(json['lastActiveAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      friends: (json['friends'] as List<dynamic>?)?.cast<String>() ?? [],
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)?.cast<String>() ?? [],
      settings: Map<String, dynamic>.from(json['settings'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'language': language,
    'xp': xp,
    'level': level,
    'gamesPlayed': gamesPlayed,
    'gamesWon': gamesWon,
    'totalScore': totalScore,
    'streak': streak,
    'coins': coins,
    'isPremium': isPremium,
    'isAdmin': isAdmin,
    'isBanned': isBanned,
    'emailVerified': emailVerified,
    'lastActiveAt': lastActiveAt,
    'createdAt': createdAt,
    'friends': friends,
    'blockedUsers': blockedUsers,
    'settings': settings,
  };

  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0;
}
