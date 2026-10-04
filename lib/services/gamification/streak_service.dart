import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/gamification/streak_model.dart';

class StreakService {
  final FirebaseFirestore _db;

  StreakService(this._db);

  Future<StreakModel?> getStreak(String userId) async {
    final doc = await _db.collection('streaks').doc(userId).get();
    if (!doc.exists) return null;
    return StreakModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<StreakModel> updateStreak(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final docRef = _db.collection('streaks').doc(userId);
    final doc = await docRef.get();

    if (!doc.exists) {
      final streak = StreakModel(
        userId: userId,
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: today,
      );
      await docRef.set(streak.toJson());
      return streak;
    }

    final data = doc.data() as Map<String, dynamic>;
    final lastActive = (data['lastActiveDate'] as Timestamp).toDate();
    final lastActiveDay = DateTime(lastActive.year, lastActive.month, lastActive.day);
    final diff = today.difference(lastActiveDay).inDays;

    int currentStreak;
    if (diff == 1) {
      currentStreak = (data['currentStreak'] as int? ?? 0) + 1;
    } else if (diff == 0) {
      currentStreak = data['currentStreak'] as int? ?? 0;
    } else {
      currentStreak = 1;
    }

    final longestStreak = data['longestStreak'] as int? ?? 0;
    final newLongest = currentStreak > longestStreak ? currentStreak : longestStreak;

    await docRef.update({
      'currentStreak': currentStreak,
      'longestStreak': newLongest,
      'lastActiveDate': today,
    });

    return StreakModel(
      userId: userId,
      currentStreak: currentStreak,
      longestStreak: newLongest,
      lastActiveDate: today,
    );
  }

  List<Map<String, dynamic>> getStreakRewards() {
    return [
      {'day': 3, 'type': 'coins', 'amount': 50, 'icon': 'coin'},
      {'day': 7, 'type': 'xp', 'amount': 200, 'icon': 'star'},
      {'day': 14, 'type': 'item', 'amount': 0, 'itemId': 'avatar_rare', 'icon': 'card'},
      {'day': 30, 'type': 'bundle', 'amount': 0, 'itemId': 'streak_master', 'icon': 'trophy'},
    ];
  }
}