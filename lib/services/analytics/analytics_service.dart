import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  Future<void> logGameStart(String gameType, int playerCount) async {
    await _analytics.logEvent(
      name: 'game_start',
      parameters: <String, Object>{
        'game_type': gameType,
        'player_count': playerCount,
      },
    );
  }

  Future<void> logGameEnd(String gameType, int duration) async {
    await _analytics.logEvent(
      name: 'game_end',
      parameters: <String, Object>{
        'game_type': gameType,
        'duration_seconds': duration,
      },
    );
  }

  Future<void> logQuestionAnswered(String questionType, bool correct) async {
    await _analytics.logEvent(
      name: 'question_answered',
      parameters: <String, Object>{
        'question_type': questionType,
        'correct': correct,
      },
    );
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logShare() async {
    await _analytics.logShare(
      contentType: 'game',
      itemId: 'share',
      method: 'share',
    );
  }

  Future<void> logPurchase(String productId, double price) async {
    await _analytics.logPurchase(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          price: price,
        ),
      ],
    );
  }

  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logError(Object error, StackTrace stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
  }
}
