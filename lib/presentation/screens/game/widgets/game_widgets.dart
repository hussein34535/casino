import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class PlayerRow extends StatelessWidget {
  final LocalPlayer player;
  final Function(int)? onScoreTap;

  const PlayerRow({super.key, required this.player, this.onScoreTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ComicColors.black,
          radius: 22,
          child: Text(player.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(player.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Row(
                children: [
                  ...List.generate(player.yellowCards, (_) => const Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.rectangle, color: ComicColors.yellow, size: 14))),
                  ...List.generate(player.redCards, (_) => const Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.rectangle, color: ComicColors.red, size: 14))),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            if (onScoreTap != null) ...[
              MiniButton(icon: Icons.remove, color: ComicColors.red, onTap: () => onScoreTap!(-1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${player.score}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
              ),
              MiniButton(icon: Icons.add, color: ComicColors.green, onTap: () => onScoreTap!(1)),
            ] else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${player.score}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
              ),
          ],
        ),
      ],
    );
  }
}

class MultiplayerRow extends StatelessWidget {
  final PlayerModel player;

  const MultiplayerRow({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ComicColors.black,
          radius: 18,
          child: Text(player.name[0], style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(player.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ),
        ComicBadge(
          text: '${player.score} pt', 
          color: ComicColors.blue,
          fontSize: 12,
        ),
      ],
    );
  }
}

class MiniButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MiniButton({super.key, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ComicColors.black, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class QuestionSection extends StatelessWidget {
  final QuestionModel? question;
  final bool audioLoadError;
  final AudioPlayer audioPlayer;
  final bool isOnline;
  final bool showAnswer;

  const QuestionSection({
    super.key,
    required this.question,
    required this.audioLoadError,
    required this.audioPlayer,
    this.isOnline = false,
    this.showAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    if (question == null) return const SizedBox();

    return ComicCard(
      color: ComicColors.yellow,
      shadowOffset: 7,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ComicTag(label: '❓ سؤال', color: ComicColors.orange),
          ),
          const SizedBox(height: 12),
          if (question!.type == 'music') ...[
            const Text('🎵', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return ComicButton(
                  label: playing ? '⏸️ وقف' : '▶️ شغّل',
                  color: playing ? ComicColors.orange : ComicColors.green,
                  textColor: Colors.white,
                  onTap: () => playing ? audioPlayer.pause() : audioPlayer.play(),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Question Text with proper sizing
          Text(
            question!.text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ComicColors.black, height: 1.3),
            textAlign: TextAlign.center,
          ),
          
          if (question!.answer != null && (!isOnline || showAnswer)) ...[
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxWidth: 250),
              child: ComicCard(
                color: ComicColors.green,
                shadowOffset: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✅ ', style: TextStyle(fontSize: 16)),
                    Flexible(
                      child: Text(
                        question!.answer!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MusicPlayerWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final bool audioLoadError;

  const MusicPlayerWidget({super.key, required this.audioPlayer, required this.audioLoadError});

  @override
  Widget build(BuildContext context) {
    if (audioLoadError) {
      return const ComicBadge(text: '⚠️ فشل تحميل الصوت', color: ComicColors.red);
    }

    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final processing = snapshot.data?.processingState;

        if (processing == ProcessingState.loading || processing == ProcessingState.buffering) {
          return const CircularProgressIndicator(color: ComicColors.blue);
        }

        return ComicButton(
          label: playing ? '⏸️ وقف الموسيقى' : '▶️ ابدأ الموسيقى',
          color: playing ? ComicColors.orange : ComicColors.green,
          textColor: Colors.white,
          onTap: () => playing ? audioPlayer.pause() : audioPlayer.play(),
        );
      },
    );
  }
}

class AnswerFeedbackOverlay extends StatefulWidget {
  final String playerName;
  final String answer;
  final bool isCorrect;
  final bool isBuzzerClaimed;

  const AnswerFeedbackOverlay({
    super.key,
    required this.playerName,
    required this.answer,
    required this.isCorrect,
    this.isBuzzerClaimed = false,
  });

  @override
  State<AnswerFeedbackOverlay> createState() => _AnswerFeedbackOverlayState();
}

class _AnswerFeedbackOverlayState extends State<AnswerFeedbackOverlay> {
  bool _isVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(AnswerFeedbackOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer || oldWidget.playerName != widget.playerName) {
      setState(() => _isVisible = true);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isVisible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBuzzerClaimed || !_isVisible) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: ComicCard(
          color: widget.answer.isEmpty ? ComicColors.orange : (widget.isCorrect ? ComicColors.green : ComicColors.red),
          padding: const EdgeInsets.all(32),
          shadowOffset: 10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                widget.answer.isEmpty 
                  ? '⏳ انتهى الوقت!'
                  : (widget.isCorrect ? '🤩 إجابة صحيحة!' : '😢 إجابة خاطئة!'),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Text(widget.playerName[0], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: ComicColors.black)),
              ).animate().shimmer(delay: 400.ms),
              const SizedBox(height: 16),
              Text(
                widget.playerName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 24),
              if (widget.answer.isNotEmpty) ...[
                const Text('قال بالظبط:', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '"${widget.answer}"',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic),
                  ),
                ),
              ] else ...[
                const Text('لم يكتب أي إجابة!', style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 32),
              Text(
                widget.answer.isEmpty ? '⏰' : (widget.isCorrect ? '✅' : '❌'),
                style: const TextStyle(fontSize: 80),
              ).animate()
               .scale(duration: 500.ms, begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
               .shake(duration: widget.isCorrect || widget.answer.isEmpty ? 0.ms : 500.ms),
            ],
          ),
          ),
        ).animate().scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)).shake(hz: widget.isCorrect ? 0 : 10),
      ),
    );
  }
}

