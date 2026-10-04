enum LogLevel { debug, info, warning, error }

class AppLogger {
  static const bool _isDebugMode = true;

  static void debug(String message) {
    if (_isDebugMode) {
      _log(LogLevel.debug, message);
    }
  }

  static void info(String message) {
    _log(LogLevel.info, message);
  }

  static void warning(String message) {
    _log(LogLevel.warning, message);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = level.name.toUpperCase();
    // ignore: avoid_print
    print('[$prefix] $timestamp: $message');
    if (error != null) {
      // ignore: avoid_print
      print('Error: $error');
    }
    if (stackTrace != null) {
      // ignore: avoid_print
      print('StackTrace: $stackTrace');
    }
  }
}
