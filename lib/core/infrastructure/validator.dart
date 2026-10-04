import 'package:game_show_app/core/constants/app_constants.dart';

class Validator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(
    r'^[\u0600-\u06FFa-zA-Z\s]{2,50}$',
  );

  static final RegExp _roomCodeRegex = RegExp(
    r'^[A-Z0-9]{4,8}$',
  );

  static String? isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (password.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    if (password.length > 128) {
      return 'كلمة المرور طويلة جداً';
    }
    if (!password.contains(RegExp(r'[A-Za-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف واحد على الأقل';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    return null;
  }

  static String? isValidName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    if (name.trim().length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    if (name.trim().length > 50) {
      return 'الاسم طويل جداً';
    }
    if (!_nameRegex.hasMatch(name.trim())) {
      return 'الاسم يجب أن يحتوي على أحرف فقط';
    }
    return null;
  }

  static String? isValidRoomCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return 'رمز الغرفة مطلوب';
    }
    final trimmed = code.trim().toUpperCase();
    if (!_roomCodeRegex.hasMatch(trimmed)) {
      return 'رمز الغرفة يجب أن يكون 4-8 أحرف وأرقام';
    }
    return null;
  }

  static String? isValidPlayerCount(int? count) {
    if (count == null) {
      return 'عدد اللاعبين مطلوب';
    }
    if (count < AppConstants.minPlayers) {
      return 'يجب أن يكون هناك لاعب واحد على الأقل';
    }
    if (count > AppConstants.maxPlayers) {
      return 'الحد الأقصى للاعبين هو ${AppConstants.maxPlayers}';
    }
    return null;
  }

  static String? isValidPhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final cleaned = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(cleaned)) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  static String? isNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? isValidAge(int? age) {
    if (age == null) return 'العمر مطلوب';
    if (age < 13) return 'يجب أن يكون عمرك 13 سنة على الأقل';
    if (age > 120) return 'يرجى إدخال عمر صحيح';
    return null;
  }
}
