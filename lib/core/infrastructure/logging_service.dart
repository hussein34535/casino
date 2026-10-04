import 'dart:async';
import 'dart:collection';
import 'package:game_show_app/core/utils/app_logger.dart';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final LogLevel level;
  final String tag;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.tag,
    required this.message,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class LoggingService {
  static const int _maxBufferSize = 100;
  static const Duration _flushInterval = Duration(seconds: 30);

  final List<LogEntry> _buffer = [];
  final Queue<LogEntry> _recentLogs = Queue();
  static const int _maxRecentLogs = 500;

  Timer? _flushTimer;

  LogLevel _minimumLevel = LogLevel.debug;

  void init({LogLevel minimumLevel = LogLevel.debug}) {
    _minimumLevel = minimumLevel;
    _flushTimer = Timer.periodic(_flushInterval, (_) => flush());
    AppLogger.info('LoggingService initialized with level: $minimumLevel');
  }

  void debug(String tag, String message) {
    _log(LogLevel.debug, tag, message);
  }

  void info(String tag, String message) {
    _log(LogLevel.info, tag, message);
  }

  void warning(String tag, String message) {
    _log(LogLevel.warning, tag, message);
  }

  void error(String tag, String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, tag, message, error, stackTrace);
  }

  void _log(LogLevel level, String tag, String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index < _minimumLevel.index) return;

    final entry = LogEntry(
      level: level,
      tag: tag,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    _buffer.add(entry);
    _recentLogs.addLast(entry);
    if (_recentLogs.length > _maxRecentLogs) {
      _recentLogs.removeFirst();
    }

    _writeToLogger(entry);

    if (_buffer.length >= _maxBufferSize) {
      flush();
    }
  }

  void _writeToLogger(LogEntry entry) {
    final formatted = '[${entry.tag}] ${entry.message}';
    switch (entry.level) {
      case LogLevel.debug:
        AppLogger.debug(formatted);
      case LogLevel.info:
        AppLogger.info(formatted);
      case LogLevel.warning:
        AppLogger.warning(formatted);
      case LogLevel.error:
        AppLogger.error(formatted, entry.error, entry.stackTrace);
    }
  }

  void flush() {
    if (_buffer.isEmpty) return;
    final snapshot = List<LogEntry>.from(_buffer);
    _buffer.clear();
    AppLogger.debug('Flushed ${snapshot.length} buffered log entries');
  }

  List<LogEntry> getRecentLogs({LogLevel? minimumLevel, String? tag}) {
    var logs = _recentLogs.toList();
    if (minimumLevel != null) {
      logs = logs.where((e) => e.level.index >= minimumLevel.index).toList();
    }
    if (tag != null) {
      logs = logs.where((e) => e.tag == tag).toList();
    }
    return logs;
  }

  List<LogEntry> getLogsByLevel(LogLevel level) {
    return _recentLogs.where((e) => e.level == level).toList();
  }

  List<LogEntry> getLogsByTag(String tag) {
    return _recentLogs.where((e) => e.tag == tag).toList();
  }

  void setMinimumLevel(LogLevel level) {
    _minimumLevel = level;
    AppLogger.info('Minimum log level set to: $level');
  }

  void clearBuffer() {
    _buffer.clear();
  }

  void clearRecentLogs() {
    _recentLogs.clear();
  }

  void dispose() {
    flush();
    _flushTimer?.cancel();
    _buffer.clear();
    _recentLogs.clear();
  }
}
