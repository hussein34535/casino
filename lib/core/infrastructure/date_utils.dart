import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy/MM/dd', 'ar');
    return formatter.format(date);
  }

  static String formatTime(DateTime date) {
    final formatter = DateFormat('hh:mm a', 'ar');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('yyyy/MM/dd hh:mm a', 'ar');
    return formatter.format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return 'منذ $minutes دقيقة';
    } else if (diff.inHours < 24) {
      final hours = diff.inHours;
      return 'منذ $hours ساعة';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      return 'منذ $days أيام';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return 'منذ $weeks أسابيع';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (diff.inDays / 365).floor();
      return 'منذ $years سنة';
    }
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static int daysBetween(DateTime a, DateTime b) {
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);
    return bDate.difference(aDate).inDays.abs();
  }

  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} يوم';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ساعة';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} دقيقة';
    } else {
      return '${duration.inSeconds} ثانية';
    }
  }

  static String formatDurationMs(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    return formatDuration(duration);
  }

  static String formatTimeRemaining(DateTime target) {
    final now = DateTime.now();
    if (target.isBefore(now)) return 'انتهى';

    final diff = target.difference(now);
    return formatDuration(diff);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return formatTime(dt);
  }

  static String dayOfWeek(DateTime date) {
    final formatter = DateFormat('EEEE', 'ar');
    return formatter.format(date);
  }

  static String monthName(DateTime date) {
    final formatter = DateFormat('MMMM', 'ar');
    return formatter.format(date);
  }
}
