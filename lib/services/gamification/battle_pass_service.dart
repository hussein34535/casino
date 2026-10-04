import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/gamification/battle_pass_model.dart';
import 'package:game_show_app/data/models/gamification/season_model.dart';

class BattlePassService {
  final FirebaseFirestore _db;

  BattlePassService(this._db);

  Future<SeasonModel?> getCurrentSeason() async {
    final snapshot = await _db.collection('seasons')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return SeasonModel.fromJson(snapshot.docs.first.data());
  }

  Future<BattlePassModel?> getBattlePass(String userId) async {
    final snapshot = await _db.collection('battlePass')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return BattlePassModel.fromJson(snapshot.docs.first.data());
  }

  Future<bool> claimReward(String battlePassId, int level) async {
    try {
      await _db.collection('battlePass').doc(battlePassId).update({
        'claimedLevels.$level': true,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> purchasePremium(String battlePassId) async {
    try {
      await _db.collection('battlePass').doc(battlePassId).update({
        'isPremium': true,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> addXp(String userId, int amount) async {
    final snapshot = await _db.collection('battlePass')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      final season = await getCurrentSeason();
      await _db.collection('battlePass').add({
        'userId': userId,
        'seasonId': season?.id ?? '',
        'level': 0,
        'xp': amount,
        'isPremium': false,
        'startedAt': FieldValue.serverTimestamp(),
      });
    } else {
      final doc = snapshot.docs.first;
      final currentXp = (doc.data()['xp'] as int? ?? 0) + amount;
      final currentLevel = (doc.data()['level'] as int? ?? 0);
      final newLevel = (currentXp / 100).floor() + 1;
      await doc.reference.update({
        'xp': currentXp,
        'level': newLevel > currentLevel ? newLevel : currentLevel,
      });
    }
  }
}