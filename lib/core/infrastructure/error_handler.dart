import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:game_show_app/core/errors/failures.dart';
import 'package:game_show_app/core/utils/app_logger.dart';

class ErrorHandler {
  static Failure handleFirebaseAuthException(dynamic e) {
    AppLogger.error('Firebase Auth Error', e);
    final code = e.code?.toString() ?? 'unknown';

    switch (code) {
      case 'user-not-found':
        return const AuthFailure(message: 'لم يتم العثور على المستخدم');
      case 'wrong-password':
        return const AuthFailure(message: 'كلمة المرور غير صحيحة');
      case 'email-already-in-use':
        return const AuthFailure(message: 'البريد الإلكتروني مستخدم بالفعل');
      case 'weak-password':
        return const AuthFailure(message: 'كلمة المرور ضعيفة جداً');
      case 'invalid-email':
        return const AuthFailure(message: 'البريد الإلكتروني غير صالح');
      case 'user-disabled':
        return const AuthFailure(message: 'تم تعطيل الحساب');
      case 'too-many-requests':
        return const AuthFailure(message: 'طلبات كثيرة جداً، حاول لاحقاً');
      case 'operation-not-allowed':
        return const AuthFailure(message: 'العملية غير مسموح بها');
      case 'network-request-failed':
        return const NetworkFailure(message: 'فشل الاتصال بالشبكة');
      default:
        return AuthFailure(message: 'خطأ في المصادقة: ${e.message ?? code}');
    }
  }

  static Failure handleFirestoreException(dynamic e) {
    AppLogger.error('Firestore Error', e);
    final code = e.code?.toString() ?? 'unknown';

    switch (code) {
      case 'permission-denied':
        return const PermissionFailure(message: 'لا تملك الصلاحية للوصول إلى هذه البيانات');
      case 'not-found':
        return const NotFoundFailure(message: 'البيانات المطلوبة غير موجودة');
      case 'already-exists':
        return const DatabaseFailure(message: 'البيانات موجودة بالفعل');
      case 'unavailable':
        return const NetworkFailure(message: 'خدمة قاعدة البيانات غير متاحة حالياً');
      case 'deadline-exceeded':
        return const NetworkFailure(message: 'انتهت مهلة الطلب');
      case 'aborted':
        return const DatabaseFailure(message: 'تم إلغاء العملية');
      case 'out-of-range':
        return const DatabaseFailure(message: 'القيمة خارج النطاق المسموح');
      case 'resource-exhausted':
        return const DatabaseFailure(message: 'تم استنفاد الموارد، حاول لاحقاً');
      case 'cancelled':
        return const DatabaseFailure(message: 'تم إلغاء العملية');
      default:
        return DatabaseFailure(message: 'خطأ في قاعدة البيانات: ${e.message ?? code}');
    }
  }

  static Failure handleNetworkException(dynamic e) {
    AppLogger.error('Network Error', e);

    if (e is FormatException) {
      return const ServerFailure(message: 'خطأ في تنسيق البيانات المستلمة');
    }

    final message = e.toString().toLowerCase();
    if (message.contains('timeout')) {
      return const NetworkFailure(message: 'انتهت مهلة الاتصال');
    }
    if (message.contains('connection refused')) {
      return const NetworkFailure(message: 'تم رفض الاتصال بالخادم');
    }
    if (message.contains('connection closed')) {
      return const NetworkFailure(message: 'تم إغلاق الاتصال');
    }
    if (message.contains('no internet') || message.contains('network is unreachable')) {
      return const NetworkFailure(message: 'لا يوجد اتصال بالإنترنت');
    }
    if (message.contains('dns')) {
      return const NetworkFailure(message: 'فشل في حل اسم الخادم');
    }
    if (message.contains('bad certificate') || message.contains('ssl')) {
      return const NetworkFailure(message: 'خطأ في شهادة الأمان');
    }

    return const NetworkFailure(message: 'خطأ في الشبكة');
  }

  static Failure handleGenericException(dynamic e, [StackTrace? stackTrace]) {
    AppLogger.error('Unexpected Error', e, stackTrace);
    FirebaseCrashlytics.instance.recordError(e, stackTrace ?? StackTrace.current, fatal: false);

    if (e is FormatException) {
      return const ServerFailure(message: 'خطأ في تنسيق البيانات');
    }
    if (e is ArgumentError) {
      return const ValidationFailure(message: 'بيانات غير صالحة');
    }
    if (e is RangeError) {
      return const ValidationFailure(message: 'قيمة خارج النطاق');
    }
    if (e is TypeError) {
      return const ServerFailure(message: 'خطأ في نوع البيانات');
    }

    return ServerFailure(message: 'حدث خطأ غير متوقع: ${e.toString()}');
  }

  static String getUserFriendlyMessage(Failure failure) {
    return failure.message;
  }
}
