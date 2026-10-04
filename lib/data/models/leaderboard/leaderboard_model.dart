import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final int score;
  final int rank;
  final int gamesPlayed;
  final int wins;
  final String period;
  final DateTime? updatedAt;

  LeaderboardEntry({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.score,
    required this.rank,
    this.gamesPlayed = 0,
    this.wins = 0,
    this.period = 'weekly',
    this.updatedAt,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return LeaderboardEntry(
      userId: json['userId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      score: json['score'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      period: json['period'] as String? ?? 'weekly',
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'score': score,
    'rank': rank,
    'gamesPlayed': gamesPlayed,
    'wins': wins,
    'period': period,
    'updatedAt': updatedAt,
  };
}
