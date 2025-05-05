import 'package:game_show_app/models/game_type.dart';

class Question {
  final String id; // معرف فريد للسؤال
  final GameType type; // نوع السؤال (من أنواع الألعاب)
  final String text; // نص السؤال أو التحدي
  final String? answer; // الإجابة الصحيحة (اختيارية)

  // حقول خاصة بأسئلة الموسيقى
  final String? audioUrl;
  final String? singerName;
  final String? songName;

  // يمكن إضافة حقول أخرى مثل: List<String> options, int points

  Question({
    required this.id,
    required this.type,
    required this.text,
    this.answer,
    this.audioUrl,
    this.singerName,
    this.songName,
  });
}
