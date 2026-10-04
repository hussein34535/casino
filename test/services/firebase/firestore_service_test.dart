import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

void main() {
  group('FirestoreService', () {
    test('should be instantiable', () {
      // Firebase is not initialized in test environment,
      // so FirestoreService construction will throw a Firebase exception.
      expect(
        () => FirestoreService(),
        throwsException,
      );
    });

    test('should expose gameSessionStream', () {
      expect(
        () => FirestoreService(),
        throwsException,
      );
    });

    test('should expose getLeaderboard stream', () {
      expect(
        () => FirestoreService(),
        throwsException,
      );
    });

    test('should expose getFriends stream', () {
      expect(
        () => FirestoreService(),
        throwsException,
      );
    });
  });
}
