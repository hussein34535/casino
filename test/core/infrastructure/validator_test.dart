import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/infrastructure/validator.dart';

void main() {
  group('Validator.isValidEmail', () {
    test('should return null for valid email', () {
      expect(Validator.isValidEmail('test@example.com'), isNull);
      expect(Validator.isValidEmail('user.name@domain.co'), isNull);
      expect(Validator.isValidEmail('user+tag@domain.com'), isNull);
    });

    test('should return error for null or empty', () {
      expect(Validator.isValidEmail(null), isNotNull);
      expect(Validator.isValidEmail(''), isNotNull);
      expect(Validator.isValidEmail('   '), isNotNull);
    });

    test('should return error for invalid email', () {
      expect(Validator.isValidEmail('not-an-email'), isNotNull);
      expect(Validator.isValidEmail('@domain.com'), isNotNull);
      expect(Validator.isValidEmail('user@'), isNotNull);
      expect(Validator.isValidEmail('user@.com'), isNotNull);
    });
  });

  group('Validator.isValidPassword', () {
    test('should return null for valid password', () {
      expect(Validator.isValidPassword('abc123'), isNull);
      expect(Validator.isValidPassword('Password1'), isNull);
      expect(Validator.isValidPassword('a1b2c3d4'), isNull);
    });

    test('should return error for null or empty', () {
      expect(Validator.isValidPassword(null), isNotNull);
      expect(Validator.isValidPassword(''), isNotNull);
    });

    test('should return error when too short', () {
      expect(Validator.isValidPassword('ab1'), isNotNull);
      expect(Validator.isValidPassword('a1'), isNotNull);
    });

    test('should return error when too long', () {
      expect(Validator.isValidPassword('a' * 129), isNotNull);
    });

    test('should return error when missing letter', () {
      expect(Validator.isValidPassword('123456'), isNotNull);
    });

    test('should return error when missing number', () {
      expect(Validator.isValidPassword('abcdef'), isNotNull);
    });
  });

  group('Validator.isValidName', () {
    test('should return null for valid names', () {
      expect(Validator.isValidName('Ahmed'), isNull);
      expect(Validator.isValidName('Mohamed Ali'), isNull);
      expect(Validator.isValidName('أحمد'), isNull);
    });

    test('should return error for null or empty', () {
      expect(Validator.isValidName(null), isNotNull);
      expect(Validator.isValidName(''), isNotNull);
      expect(Validator.isValidName('   '), isNotNull);
    });

    test('should return error when too short', () {
      expect(Validator.isValidName('A'), isNotNull);
    });

    test('should return error when too long', () {
      expect(Validator.isValidName('A' * 51), isNotNull);
    });

    test('should return error for invalid characters', () {
      expect(Validator.isValidName('John123'), isNotNull);
      expect(Validator.isValidName('User@Name'), isNotNull);
    });
  });

  group('Validator.isValidPlayerCount', () {
    test('should return null for valid counts', () {
      expect(Validator.isValidPlayerCount(1), isNull);
      expect(Validator.isValidPlayerCount(5), isNull);
      expect(Validator.isValidPlayerCount(10), isNull);
    });

    test('should return error for null', () {
      expect(Validator.isValidPlayerCount(null), isNotNull);
    });

    test('should return error for count below minimum', () {
      expect(Validator.isValidPlayerCount(0), isNotNull);
    });

    test('should return error for count above maximum', () {
      expect(Validator.isValidPlayerCount(11), isNotNull);
    });
  });

  group('Validator.isValidRoomCode', () {
    test('should return null for valid room codes', () {
      expect(Validator.isValidRoomCode('ABCD'), isNull);
      expect(Validator.isValidRoomCode('1234'), isNull);
      expect(Validator.isValidRoomCode('ABCD1234'), isNull);
    });

    test('should return error for null or empty', () {
      expect(Validator.isValidRoomCode(null), isNotNull);
      expect(Validator.isValidRoomCode(''), isNotNull);
    });

    test('should return error when too short', () {
      expect(Validator.isValidRoomCode('AB'), isNotNull);
    });

    test('should return error when too long', () {
      expect(Validator.isValidRoomCode('ABCDEFGHI'), isNotNull);
    });

    test('should return error for invalid characters', () {
      expect(Validator.isValidRoomCode('ab@1'), isNotNull);
      expect(Validator.isValidRoomCode('AB CD'), isNotNull);
    });

    test('should convert to uppercase', () {
      expect(Validator.isValidRoomCode('abcd'), isNull);
    });
  });
}
