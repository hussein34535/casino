import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/domain/usecases/game/validate_player_count.dart';

void main() {
  group('ValidatePlayerCount', () {
    late ValidatePlayerCount useCase;

    setUp(() {
      useCase = ValidatePlayerCount();
    });

    group('valid counts', () {
      test('minimum of 2 players is valid', () {
        expect(() => useCase.call(2), returnsNormally);
      });

      test('maximum of 10 players is valid', () {
        expect(() => useCase.call(10), returnsNormally);
      });

      test('5 players is valid', () {
        expect(() => useCase.call(5), returnsNormally);
      });

      test('all counts from 2 to 10 are valid', () {
        for (int i = 2; i <= 10; i++) {
          expect(() => useCase.call(i), returnsNormally);
        }
      });
    });

    group('invalid counts', () {
      test('1 player throws ValidationFailure', () {
        expect(
          () => useCase.call(1),
          throwsA(isA<ValidationFailure>()),
        );
      });

      test('0 players throws ValidationFailure', () {
        expect(
          () => useCase.call(0),
          throwsA(isA<ValidationFailure>()),
        );
      });

      test('11 players throws ValidationFailure', () {
        expect(
          () => useCase.call(11),
          throwsA(isA<ValidationFailure>()),
        );
      });

      test('negative count throws ValidationFailure', () {
        expect(
          () => useCase.call(-1),
          throwsA(isA<ValidationFailure>()),
        );
      });
    });

    test('ValidationFailure contains appropriate message for minimum', () {
      try {
        useCase.call(1);
        fail('Expected ValidationFailure');
      } on ValidationFailure catch (e) {
        expect(e.message, contains('2'));
      }
    });

    test('ValidationFailure contains appropriate message for maximum', () {
      try {
        useCase.call(11);
        fail('Expected ValidationFailure');
      } on ValidationFailure catch (e) {
        expect(e.message, contains('10'));
      }
    });
  });
}
