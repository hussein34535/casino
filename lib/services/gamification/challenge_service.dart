import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/gamification/daily_challenge_model.dart';

class ChallengeService {
  final FirebaseFirestore _db;

  ChallengeService(this._db);

  Future<List<DailyChallengeModel>> getDailyChallenges() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snapshot = await _db.collection('challenges')
        .where('period', isEqualTo: 'daily')
        .where('expiresAt', isGreaterThanOrEqualTo: startOfDay)
        .where('expiresAt', isLessThan: endOfDay)
        .get();
    if (snapshot.docs.isEmpty) return _generateDefaultDaily();
    return snapshot.docs.map((d) => DailyChallengeModel.fromJson(d.data())).toList();
  }

  Future<List<DailyChallengeModel>> getWeeklyChallenges() async {
    final snapshot = await _db.collection('challenges')
        .where('period', isEqualTo: 'weekly')
        .limit(3)
        .get();
    if (snapshot.docs.isEmpty) return _generateDefaultWeekly();
    return snapshot.docs.map((d) => DailyChallengeModel.fromJson(d.data())).toList();
  }

  Future<List<DailyChallengeModel>> getMonthlyChallenges() async {
    final snapshot = await _db.collection('challenges')
        .where('period', isEqualTo: 'monthly')
        .limit(3)
        .get();
    if (snapshot.docs.isEmpty) return _generateDefaultMonthly();
    return snapshot.docs.map((d) => DailyChallengeModel.fromJson(d.data())).toList();
  }

  Future<void> updateProgress(String userId, String challengeId, int progress) async {
    final docRef = _db.collection('userChallenges').doc('${userId}_$challengeId');
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'userId': userId,
        'challengeId': challengeId,
        'progress': progress,
        'isCompleted': false,
        'rewardClaimed': false,
        'startedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({'progress': FieldValue.increment(progress)});
    }
  }

  List<DailyChallengeModel> _generateDefaultDaily() {
    return [
      DailyChallengeModel(
        id: 'daily_score_${DateTime.now().day}',
        title: {'ar': 'جامع النقاط', 'en': 'Score Collector'},
        description: {'ar': 'احصل على 50 نقطة في لعبة واحدة', 'en': 'Get 50 points in one game'},
        xpReward: 100,
        coinReward: 50,
        requiredProgress: 50,
        requiredAmount: 50,
        type: ChallengeType.daily,
        period: ChallengePeriod.daily,
        iconName: 'star',
      ),
      DailyChallengeModel(
        id: 'daily_games_${DateTime.now().day}',
        title: {'ar': 'مدمن ألعاب', 'en': 'Game Addict'},
        description: {'ar': 'العب 3 ألعاب اليوم', 'en': 'Play 3 games today'},
        xpReward: 200,
        coinReward: 100,
        requiredProgress: 3,
        requiredAmount: 3,
        type: ChallengeType.daily,
        period: ChallengePeriod.daily,
        iconName: 'games',
      ),
      DailyChallengeModel(
        id: 'daily_streak_${DateTime.now().day}',
        title: {'ar': 'استمرارية', 'en': 'Continuity'},
        description: {'ar': 'حافظ على streak 5 أيام', 'en': 'Maintain a 5-day streak'},
        xpReward: 150,
        coinReward: 75,
        requiredProgress: 5,
        requiredAmount: 5,
        type: ChallengeType.daily,
        period: ChallengePeriod.daily,
        iconName: 'fire',
      ),
    ];
  }

  List<DailyChallengeModel> _generateDefaultWeekly() {
    return [
      DailyChallengeModel(
        id: 'weekly_winner',
        title: {'ar': 'بطل الأسبوع', 'en': 'Weekly Winner'},
        description: {'ar': 'اربح 10 ألعاب هذا الأسبوع', 'en': 'Win 10 games this week'},
        xpReward: 500,
        coinReward: 250,
        requiredProgress: 10,
        requiredAmount: 10,
        type: ChallengeType.weekly,
        period: ChallengePeriod.weekly,
        iconName: 'trophy',
      ),
      DailyChallengeModel(
        id: 'weekly_score',
        title: {'ar': 'تحدي النقاط', 'en': 'Score Challenge'},
        description: {'ar': 'اجمع 500 نقطة إجمالي هذا الأسبوع', 'en': 'Collect 500 total points this week'},
        xpReward: 400,
        coinReward: 200,
        requiredProgress: 500,
        requiredAmount: 500,
        type: ChallengeType.weekly,
        period: ChallengePeriod.weekly,
        iconName: 'score',
      ),
    ];
  }

  List<DailyChallengeModel> _generateDefaultMonthly() {
    return [
      DailyChallengeModel(
        id: 'monthly_champ',
        title: {'ar': 'بطل الشهر', 'en': 'Monthly Champion'},
        description: {'ar': 'اربح 50 لعبة هذا الشهر', 'en': 'Win 50 games this month'},
        xpReward: 500,
        coinReward: 1000,
        requiredProgress: 50,
        requiredAmount: 50,
        type: ChallengeType.monthly,
        period: ChallengePeriod.monthly,
        iconName: 'crown',
      ),
    ];
  }
}