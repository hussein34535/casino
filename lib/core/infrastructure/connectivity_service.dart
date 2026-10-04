import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:game_show_app/core/utils/app_logger.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    try {
      final dynamic result = await _connectivity.checkConnectivity();
      if (result is List) {
        return result.any((r) => r != ConnectivityResult.none);
      }
      return (result as ConnectivityResult) != ConnectivityResult.none;
    } catch (e) {
      AppLogger.error('Failed to check connectivity', e);
      return false;
    }
  }

  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (dynamic result) {
        if (result is List) {
          return result.any((r) => r != ConnectivityResult.none);
        }
        return (result as ConnectivityResult) != ConnectivityResult.none;
      },
    );
  }

  Future<ConnectivityResult> getCurrentResult() async {
    try {
      final dynamic result = await _connectivity.checkConnectivity();
      if (result is List) {
        return result.isEmpty ? ConnectivityResult.none : (result.first as ConnectivityResult);
      }
      return result as ConnectivityResult;
    } catch (e) {
      AppLogger.error('Failed to get connectivity result', e);
      return ConnectivityResult.none;
    }
  }
}
