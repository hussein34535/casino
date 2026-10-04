// Task 508: Emergency Broadcast System
class EmergencySystem {
  static final EmergencySystem _instance = EmergencySystem._();
  factory EmergencySystem() => _instance;
  EmergencySystem._();

  bool _isEmergencyMode = false;
  String? _currentMessage;
  final List<EmergencyAlert> _alerts = [];

  void triggerEmergency(String message, EmergencyLevel level) {
    _isEmergencyMode = true;
    _currentMessage = message;
    _alerts.add(EmergencyAlert(
      message: message,
      level: level,
      timestamp: DateTime.now(),
    ));
  }

  void clearEmergency() {
    _isEmergencyMode = false;
    _currentMessage = null;
  }

  bool get isEmergencyActive => _isEmergencyMode;
  String? get currentMessage => _currentMessage;

  void scheduleMaintenance(DateTime startTime, int durationMinutes) {
    _alerts.add(EmergencyAlert(
      message: 'صيانة مجدولة: ستبدأ في $startTime لمدة $durationMinutes دقيقة',
      level: EmergencyLevel.maintenance,
      timestamp: DateTime.now(),
    ));
  }

  // Game-wide announcements
  Future<void> broadcastToAllPlayers(String message) async {
    // TODO: Push notification + in-app banner to all active sessions
    _alerts.add(EmergencyAlert(
      message: message,
      level: EmergencyLevel.info,
      timestamp: DateTime.now(),
    ));
  }

  List<EmergencyAlert> get recentAlerts =>
      _alerts.reversed.take(50).toList();
}

enum EmergencyLevel { info, warning, critical, maintenance }

class EmergencyAlert {
  final String message;
  final EmergencyLevel level;
  final DateTime timestamp;

  EmergencyAlert({
    required this.message,
    required this.level,
    required this.timestamp,
  });
}

final emergencySystem = EmergencySystem();
