import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/services/notifications/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Fire-and-forget provider: initializes notifications in the background
// WITHOUT blocking the UI thread. Use ref.listen in the widget tree, not ref.watch.
final notificationInitializerProvider = Provider<void>((ref) {
  final service = ref.read(notificationServiceProvider);
  // Run asynchronously so the build() method is never blocked
  Future.microtask(() => service.initialize());
});
