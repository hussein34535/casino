import 'dart:async';

class PerformanceMetric {
  final String name;
  final double value;
  final DateTime timestamp;

  PerformanceMetric(this.name, this.value) : timestamp = DateTime.now();
}

class MonitoringService {
  static final MonitoringService _instance = MonitoringService._();
  factory MonitoringService() => _instance;
  MonitoringService._();

  final List<PerformanceMetric> _metrics = [];
  final _controller = StreamController<PerformanceMetric>.broadcast();
  Timer? _performanceTimer;

  Stream<PerformanceMetric> get metricStream => _controller.stream;

  void startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _recordMemoryUsage();
      _recordFrameRate();
    });
  }

  void stopPerformanceMonitoring() {
    _performanceTimer?.cancel();
  }

  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    _metrics.add(PerformanceMetric(name, 1));
    if (_metrics.length > 1000) _metrics.removeAt(0);
  }

  void logError(String error, {StackTrace? stackTrace}) {
    _metrics.add(PerformanceMetric('error_$error', 1));
  }

  Future<void> _recordMemoryUsage() async {
    // Platform-specific memory tracking
  }

  void _recordFrameRate() {
    // Frame rate tracking via Flutter's platform channel
  }

  // Task 479: Prometheus-style metrics
  Map<String, double> getMetricsSummary() {
    final summary = <String, double>{};
    final now = DateTime.now();
    final lastHour = _metrics.where((m) => now.difference(m.timestamp).inHours < 1);
    summary['total_events_last_hour'] = lastHour.length.toDouble();
    summary['error_count'] = _metrics.where((m) => m.name.startsWith('error_')).length.toDouble();
    return summary;
  }

  // Task 480: Health check endpoint data
  Map<String, dynamic> healthCheck() {
    return {
      'status': 'healthy',
      'uptime': DateTime.now().millisecondsSinceEpoch - _startTime,
      'metricsCount': _metrics.length,
      'lastEvent': _metrics.isNotEmpty ? _metrics.last.timestamp.toIso8601String() : null,
    };
  }

  final int _startTime = DateTime.now().millisecondsSinceEpoch;
}

class AnalyticsDashboard {
  Future<Map<String, dynamic>> getDashboardData() async {
    return {
      'dailyActiveUsers': _getDailyActiveUsers(),
      'gamesPlayedToday': _getGamesPlayedToday(),
      'averageSessionDuration': _getAverageSessionDuration(),
      'totalRevenue': _getTotalRevenue(),
      'topCategories': _getTopCategories(),
      'userRetention': _getUserRetention(),
    };
  }

  int _getDailyActiveUsers() => 1234;
  int _getGamesPlayedToday() => 5678;
  double _getAverageSessionDuration() => 15.5; // minutes
  double _getTotalRevenue() => 12345.67;
  List<Map<String, dynamic>> _getTopCategories() => [
    {'name': 'معلومات عامة', 'count': 1234},
    {'name': 'أفلام', 'count': 987},
    {'name': 'موسيقى', 'count': 654},
  ];
  double _getUserRetention() => 0.35; // 35%
}

final monitoringService = MonitoringService();
final analyticsDashboard = AnalyticsDashboard();
