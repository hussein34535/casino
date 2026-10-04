import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_show_app/core/utils/app_logger.dart';

class SessionData {
  final String token;
  final DateTime expiry;

  SessionData({required this.token, required this.expiry});

  bool get isValid => DateTime.now().isBefore(expiry);

  Map<String, dynamic> toJson() => {
    'token': token,
    'expiry': expiry.toIso8601String(),
  };

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
    token: json['token'] as String,
    expiry: DateTime.parse(json['expiry'] as String),
  );
}

class SessionManager {
  static const String _tokenKey = 'session_token';
  static const String _expiryKey = 'session_expiry';

  SessionData? _session;

  Future<SessionData?> getSession() async {
    if (_session != null && _session!.isValid) return _session;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryStr = prefs.getString(_expiryKey);

    if (token == null || expiryStr == null) return null;

    try {
      final expiry = DateTime.parse(expiryStr);
      _session = SessionData(token: token, expiry: expiry);
      if (!_session!.isValid) {
        await clearSession();
        return null;
      }
      return _session;
    } catch (e) {
      AppLogger.error('Failed to parse session data', e);
      return null;
    }
  }

  Future<void> setSession(String token, DateTime expiry) async {
    _session = SessionData(token: token, expiry: expiry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expiryKey, expiry.toIso8601String());
    AppLogger.info('Session set, expires at: $expiry');
  }

  Future<bool> isValid() async {
    final session = await getSession();
    return session != null && session.isValid;
  }

  Future<void> clearSession() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
    AppLogger.info('Session cleared');
  }

  Future<SessionData?> refreshSession() async {
    final current = await getSession();
    if (current == null) return null;

    final newExpiry = DateTime.now().add(const Duration(days: 7));
    await setSession(current.token, newExpiry);
    AppLogger.info('Session refreshed, new expiry: $newExpiry');
    return _session;
  }

  Future<String?> getToken() async {
    final session = await getSession();
    return session?.token;
  }

  Future<DateTime?> getExpiry() async {
    final session = await getSession();
    return session?.expiry;
  }

  Future<Duration> getTimeUntilExpiry() async {
    final session = await getSession();
    if (session == null) return Duration.zero;
    return session.expiry.difference(DateTime.now());
  }
}
