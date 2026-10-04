import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/domain/usecases/user/calculate_level.dart';

void main() {
  group('CalculateLevel', () {
    late CalculateLevel useCase;

    setUp(() {
      useCase = CalculateLevel();
    });

    test('returns level 1 for 0 XP', () {
      expect(useCase.call(0), 1);
    });

    test('returns level 1 for XP less than 100', () {
      expect(useCase.call(50), 1);
      expect(useCase.call(99), 1);
    });

    test('returns level 2 for exactly 100 XP', () {
      expect(useCase.call(100), 2);
    });

    test('returns level 2 for XP between 100 and 199', () {
      expect(useCase.call(150), 2);
      expect(useCase.call(199), 2);
    });

    test('returns level 5 for 400 XP', () {
      expect(useCase.call(400), 5);
    });

    test('returns level 10 for 900 XP', () {
      expect(useCase.call(900), 10);
    });

    test('returns level 11 for 1000 XP', () {
      expect(useCase.call(1000), 11);
    });

    test('handles large XP values', () {
      expect(useCase.call(10000), 101);
      expect(useCase.call(100000), 1001);
    });

    test('formula: (xp / 100).floor() + 1', () {
      for (int xp = 0; xp < 1000; xp += 50) {
        final expected = (xp / 100).floor() + 1;
        expect(useCase.call(xp), expected);
      }
    });
  });
}
