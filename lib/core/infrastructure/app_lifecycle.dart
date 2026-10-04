import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

enum AppLifecycleStateEx {
  started,
  background,
  foreground,
  exited,
}

class AppLifecycleManager with WidgetsBindingObserver {
  final FirestoreService _firestoreService;
  String? _userId;
  final StreamController<AppLifecycleStateEx> _stateController =
      StreamController<AppLifecycleStateEx>.broadcast();

  AppLifecycleStateEx _currentState = AppLifecycleStateEx.started;

  AppLifecycleManager(this._firestoreService, [this._userId]);

  AppLifecycleStateEx get currentState => _currentState;
  Stream<AppLifecycleStateEx> get stateStream => _stateController.stream;

  void setUserId(String userId) {
    _userId = userId;
  }

  void onAppStart() {
    _currentState = AppLifecycleStateEx.started;
    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('App started');
    _stateController.add(AppLifecycleStateEx.started);
  }

  void onAppBackground() async {
    _currentState = AppLifecycleStateEx.background;
    AppLogger.info('App moved to background');
    _stateController.add(AppLifecycleStateEx.background);

    if (_userId != null) {
      try {
        await _firestoreService.updateUser(_userId!, {
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
        AppLogger.debug('Updated lastActiveAt for user: $_userId');
      } catch (e) {
        AppLogger.error('Failed to update lastActiveAt', e);
      }
    }
  }

  void onAppForeground() {
    _currentState = AppLifecycleStateEx.foreground;
    AppLogger.info('App moved to foreground');
    _stateController.add(AppLifecycleStateEx.foreground);
  }

  void onAppExit() {
    _currentState = AppLifecycleStateEx.exited;
    WidgetsBinding.instance.removeObserver(this);
    AppLogger.info('App exiting');
    _stateController.add(AppLifecycleStateEx.exited);
    _stateController.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        onAppBackground();
      case AppLifecycleState.resumed:
        onAppForeground();
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        onAppExit();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateController.close();
  }
}

final appLifecycleManagerProvider = Provider<AppLifecycleManager>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final manager = AppLifecycleManager(firestoreService);
  manager.onAppStart();
  ref.onDispose(() => manager.dispose());
  return manager;
});

