import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/services/analytics/analytics_service.dart';

class AnalyticsHelper {
  final AnalyticsService _analyticsService;

  AnalyticsHelper(this._analyticsService);

  Future<void> logGameStarted(String type) async {
    try {
      await _analyticsService.logGameStart(type, 0);
      AppLogger.debug('Analytics: game started - $type');
    } catch (e) {
      AppLogger.error('Failed to log game start', e);
    }
  }

  Future<void> logGameEnded(String type, int score) async {
    try {
      await _analyticsService.logGameEnd(type, score);
      AppLogger.debug('Analytics: game ended - $type, score: $score');
    } catch (e) {
      AppLogger.error('Failed to log game end', e);
    }
  }

  Future<void> logQuestionAnswered(bool correct) async {
    try {
      await _analyticsService.logQuestionAnswered('general', correct);
      AppLogger.debug('Analytics: question answered - correct: $correct');
    } catch (e) {
      AppLogger.error('Failed to log question answered', e);
    }
  }

  Future<void> logLogin(String method) async {
    try {
      await _analyticsService.logLogin(method);
      AppLogger.debug('Analytics: login - $method');
    } catch (e) {
      AppLogger.error('Failed to log login', e);
    }
  }

  Future<void> logSignUp(String method) async {
    try {
      await _analyticsService.logSignUp(method);
      AppLogger.debug('Analytics: sign up - $method');
    } catch (e) {
      AppLogger.error('Failed to log sign up', e);
    }
  }

  Future<void> logPurchase(String itemId, double price) async {
    try {
      await _analyticsService.logPurchase(itemId, price);
      AppLogger.debug('Analytics: purchase - $itemId, price: $price');
    } catch (e) {
      AppLogger.error('Failed to log purchase', e);
    }
  }

  Future<void> logShare(String contentType) async {
    try {
      await _analyticsService.logShare();
      AppLogger.debug('Analytics: share - $contentType');
    } catch (e) {
      AppLogger.error('Failed to log share', e);
    }
  }

  Future<void> logScreenView(String screenName) async {
    try {
      await _analyticsService.analytics.logScreenView(
        screenName: screenName,
      );
      AppLogger.debug('Analytics: screen view - $screenName');
    } catch (e) {
      AppLogger.error('Failed to log screen view', e);
    }
  }

  Future<void> logCustomEvent(String name, Map<String, Object> parameters) async {
    try {
      await _analyticsService.analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      AppLogger.debug('Analytics: custom event - $name');
    } catch (e) {
      AppLogger.error('Failed to log custom event', e);
    }
  }
}
