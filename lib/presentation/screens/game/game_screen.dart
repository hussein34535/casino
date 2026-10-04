import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/presentation/screens/game/widgets/game_widgets.dart';

class GameScreen extends ConsumerStatefulWidget {
  final String gameType;
  final bool isChangingType;
  const GameScreen({super.key, required this.gameType, this.isChangingType = false});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late AudioPlayer _audioPlayer;
  final bool _audioLoadError = false;
  int _answerTimerSeconds = 20;
  Timer? _answerTimer;
  final TextEditingController _answerController = TextEditingController();
  bool _isWinnerDialogShown = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _startAnswerTimer(String buzzerPlayerId, String currentUserId, String currentAnswer) {
    _answerTimer?.cancel();
    setState(() => _answerTimerSeconds = 20);
    _answerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_answerTimerSeconds > 0) {
        setState(() => _answerTimerSeconds--);
      } else {
        timer.cancel();
        if (buzzerPlayerId == currentUserId) {
          ref.read(gameStateProvider.notifier).submitAnswerOnline(currentUserId, '', currentAnswer);
        }
      }
    });
  }

  void _triggerBotAnswer() {
    if (!mounted) return;
    final gameState = ref.read(gameStateProvider);
    if (!gameState.isBotMode) return;
    
    // Bot answers after a short delay (simulating thinking time)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        ref.read(gameStateProvider.notifier).botAnswerQuestion(playerAnswerCorrect: false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _answerTimer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _showWinnerSelectionDialog(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(gameStateProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: ComicColors.black, width: 4),
        ),
        title: const Text('🎯 من جاوب صح؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black, fontSize: 24)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: gameState.players.length,
            itemBuilder: (context, index) {
              final player = gameState.players[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ComicButton(
                        label: player.name,
                        color: ComicColors.blue,
                        textColor: Colors.white,
                        onTap: () {
                          ref.read(gameStateProvider.notifier).updateScore(index, 1);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ComicButton(
                      label: '❌',
                      color: ComicColors.red,
                      textColor: Colors.white,
                      fontSize: 16,
                      onTap: () {
                        ref.read(gameStateProvider.notifier).updateScore(index, -1);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showOfflineCardMenu(BuildContext context, int index, String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: ComicColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: ComicColors.black, width: 4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🃏 إدارة اللاعب: $name', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ComicButton(
                    label: '🟨 كرت أصفر',
                    color: ComicColors.yellow,
                    onTap: () {
                      ref.read(gameStateProvider.notifier).giveYellowCard(index);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ComicButton(
                    label: '🟥 كرت أحمر',
                    color: ComicColors.red,
                    textColor: Colors.white,
                    onTap: () {
                      ref.read(gameStateProvider.notifier).giveRedCard(index);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ComicButton(
              label: 'إلغاء',
              color: ComicColors.grey,
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final roomSession = ref.watch(roomSessionStreamProvider).valueOrNull;
    final currentRoomId = ref.watch(currentRoomIdProvider);
    final isMultiplayer = currentRoomId != null;
    final currentUser = ref.watch(authStateProvider).value;
    final syncedPlayers = ref.watch(syncedPlayersProvider);
    
    final currentQuestionIndex = ref.watch(syncedQuestionIndexProvider);
    final gameNotifier = ref.read(gameStateProvider.notifier);

    // Determine the current question safely
    QuestionModel? currentQuestion;
    if (gameState.questions.isNotEmpty && currentQuestionIndex < gameState.questions.length) {
      currentQuestion = gameState.questions[currentQuestionIndex];
    }

    final buzzerPlayerId = roomSession?.buzzerPlayerId;
    final isBuzzerClaimed = buzzerPlayerId != null;
    final isMyBuzzer = buzzerPlayerId == currentUser?.id;
    final hasVotedNext = roomSession?.nextVotes.contains(currentUser?.id) ?? false;
    final showAnswer = roomSession?.showAnswer ?? false;

    // Listen for question changes to load audio
    ref.listen<int>(syncedQuestionIndexProvider, (prev, next) {
      if (gameState.questions.isNotEmpty && next < gameState.questions.length) {
        final q = gameState.questions[next];
        if (q.type == 'music' && q.audioUrl != null) {
          _audioPlayer.setUrl(q.audioUrl!);
        }
        // Trigger bot answer in bot mode
        if (gameState.isBotMode) {
          _triggerBotAnswer();
        }
      }
    });

    // Listen for buzzer changes to start answer timer
    ref.listen<String?>(
      roomSessionStreamProvider.select((p) => p.valueOrNull?.buzzerPlayerId),
      (prev, next) {
        if (next != null && prev == null) {
          _startAnswerTimer(next, currentUser?.id ?? '', currentQuestion?.answer ?? '');
        } else if (next == null) {
          _answerTimer?.cancel();
        }
      },
    );

    // The app is the host: when a player reaches the winning score the room
    // finishes for everyone at the same time — no player decides the winner.
    ref.listen<String?>(
      roomSessionStreamProvider.select((p) => p.valueOrNull?.winnerId),
      (prev, next) {
        if (next != null && next.isNotEmpty && !_isWinnerDialogShown) {
          _isWinnerDialogShown = true;
          final players =
              ref.read(roomSessionStreamProvider).valueOrNull?.players ?? const [];
          String name = 'الفائز';
          for (final p in players) {
            if (p.id == next) {
              name = p.name;
              break;
            }
          }
          _showFinalWinnerDialog(context, name);
        }
      },
    );

    if (gameState.isLoading) {
      return const Scaffold(
        backgroundColor: ComicColors.cream,
        body: Center(child: CircularProgressIndicator(color: ComicColors.blue)),
      );
    }

    if (gameState.winnerId != null && !_isWinnerDialogShown) {
      _isWinnerDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFinalWinnerDialog(context, gameState.winnerId!);
      });
    }

    // App-driven finish: if the questions run out before anyone hits the
    // winning score, the app declares the current leader for every device.
    if (isMultiplayer &&
        gameState.questions.isNotEmpty &&
        currentQuestionIndex >= gameState.questions.length &&
        roomSession?.winnerId == null &&
        syncedPlayers.isNotEmpty &&
        !_isWinnerDialogShown) {
      _isWinnerDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFinalWinnerDialog(context, syncedPlayers.first.name);
      });
    }

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '🎯 ${gameState.selectedCategories?.isNotEmpty == true ? gameState.selectedCategories!.join(" + ") : 'GAME'}',
          style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black, fontSize: 14),
        ),
        automaticallyImplyLeading: false,
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        actions: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: ComicBadge(text: 'Q: ${currentQuestionIndex + 1}', color: ComicColors.orange),
           ),
        ],
      ),
      body: Stack(
        children: [
          ComicBackground(
            bgColor: ComicColors.cream,
            dotColor: ComicColors.blue,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (currentQuestion != null) ...[
                            QuestionSection(
                              question: currentQuestion,
                              audioLoadError: _audioLoadError,
                              audioPlayer: _audioPlayer,
                              isOnline: isMultiplayer,
                              showAnswer: showAnswer,
                            ),
                            
                            if (isMultiplayer && isMyBuzzer) ...[
                              const SizedBox(height: 16),
                              ComicCard(
                                color: ComicColors.yellow,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.timer, size: 36, color: ComicColors.red),
                                        const SizedBox(width: 8),
                                        Text('$_answerTimerSeconds', style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.red, fontSize: 40)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('أسرع! اكتب إجابتك الآن:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _answerController,
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'الإجابة...',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(width: 3)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(width: 3)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(width: 3, color: ComicColors.blue)),
                                      ),
                                      onSubmitted: (val) {
                                        if (val.trim().isNotEmpty) {
                                          gameNotifier.submitAnswerOnline(currentUser!.id, val, currentQuestion?.answer ?? '');
                                          _answerController.clear();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ComicButton(
                                      label: 'إرسال ✅',
                                      color: ComicColors.green,
                                      textColor: Colors.white,
                                      onTap: () {
                                        if (_answerController.text.trim().isNotEmpty) {
                                          gameNotifier.submitAnswerOnline(currentUser!.id, _answerController.text, currentQuestion?.answer ?? '');
                                          _answerController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: 24),

                            // Bot Thinking / Answer Feedback
                            if (gameState.isBotMode && gameState.isBotThinking)
                              ComicCard(
                                color: ComicColors.purple,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shadowOffset: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const XoIcon('brain',
                                        color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${gameState.players.length > 1 ? gameState.players[1].name : 'البوت'} يفكر...',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                            if (gameState.isBotMode && !gameState.isBotThinking && gameState.lastBotAnswerCorrect != null)
                              ComicCard(
                                color: gameState.lastBotAnswerCorrect! ? ComicColors.green : ComicColors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shadowOffset: 4,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gameState.lastBotAnswerCorrect! ? '✅' : '❌',
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          gameState.lastBotAnswerCorrect!
                                              ? 'البوت جاوب صح!'
                                              : 'البوت جاوب غلط!',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (gameState.botTaunt != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        '💬 ${gameState.botTaunt}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

                            const SizedBox(height: 24),
                            
                            // Player List (Compact Layout)
                            if (isMultiplayer)
                              ...syncedPlayers.map((player) {
                                final cardColors = [ComicColors.blue, ComicColors.purple, ComicColors.green, ComicColors.orange, ComicColors.pink];
                                final index = syncedPlayers.indexOf(player);
                                final hasVoted = roomSession?.nextVotes.contains(player.id) ?? false;
                                final isBuzzerOwner = roomSession?.buzzerPlayerId == player.id;
                                final isAnswering = roomSession?.lastAnswerPlayerId == player.id;
                                final isLastCorrect = roomSession?.isLastAnswerCorrect ?? false;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ComicCard(
                                    color: isBuzzerOwner ? ComicColors.yellow : cardColors[index % cardColors.length],
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shadowOffset: 4,
                                    child: Row(
                                      children: [
                                        Expanded(child: MultiplayerRow(player: player)),
                                        if (hasVoted) 
                                          const Icon(Icons.check_circle, color: ComicColors.green, size: 20),
                                        if (isBuzzerOwner) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: ComicColors.red,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: ComicColors.black, width: 2)
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.timer, color: Colors.white, size: 16),
                                                const SizedBox(width: 4),
                                                Text('$_answerTimerSeconds', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                  // Entry animation (always runs once when player appears)
                                  .animate()
                                  .fadeIn(delay: (index * 100).ms)
                                  .slideX(begin: 0.1, end: 0)
                                  // Feedback animation (only triggers when player is answering)
                                  .then(delay: 0.ms)
                                  .animate(target: isAnswering ? 1 : 0)
                                  .shake(hz: isLastCorrect ? 0 : 10, duration: 500.ms)
                                  .scale(begin: const Offset(1, 1), end: isLastCorrect ? const Offset(1.1, 1.1) : const Offset(1, 1), duration: 400.ms),
                                );
                              })
                            else
                              ...gameState.players.map((player) {
                                final index = gameState.players.indexOf(player);
                                final cardColors = [ComicColors.blue, ComicColors.purple, ComicColors.green, ComicColors.orange, ComicColors.pink];
                                final isBotPlayer = player.isBot;
                                final isThinking = gameState.isBotThinking && isBotPlayer;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: ComicCard(
                                    onLongPress: isBotPlayer ? null : () => _showOfflineCardMenu(context, index, player.name),
                                    color: isThinking ? ComicColors.purple : cardColors[index % cardColors.length],
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shadowOffset: 5,
                                    child: Row(
                                      children: [
                                        if (isBotPlayer)
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            margin: const EdgeInsets.only(left: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const XoIcon('brain',
                                                size: 16, color: ComicColors.purple),
                                          ),
                                        Expanded(
                                          child: PlayerRow(
                                            player: player,
                                            onScoreTap: isBotPlayer ? null : (delta) => gameNotifier.updateScore(index, delta),
                                          ),
                                        ),
                                        if (isThinking)
                                          const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ).animate().fadeIn(delay: (index * 150).ms).slideX(begin: 0.2, end: 0),
                                );
                              }),
                          ] else ...[
                            const Center(child: Text('انتهاء الأسئلة!')),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  // Controls Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: ComicColors.black, width: 3)),
                    ),
                    child: Row(
                      children: [
                        if (isMultiplayer) ...[
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: isBuzzerClaimed
                                  ? null
                                  : () => gameNotifier.claimBuzzer(currentUser!.id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isBuzzerClaimed
                                      ? ComicColors.grey
                                      : ComicColors.red,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: ComicColors.black, width: 3),
                                  boxShadow: !isBuzzerClaimed
                                      ? const [
                                          BoxShadow(
                                              color: ComicColors.black,
                                              offset: Offset(4, 4),
                                              blurRadius: 0)
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: isBuzzerClaimed
                                      ? const Icon(Icons.lock,
                                          color: Colors.white, size: 28)
                                      : const Icon(Icons.notifications_active_rounded,
                                          color: Colors.white, size: 32),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: ComicButton(
                              label:
                                  hasVotedNext ? '⌛ بانتظار البقية' : '⏭️ التالي',
                              color:
                                  hasVotedNext ? ComicColors.grey : ComicColors.blue,
                              textColor: Colors.white,
                              onTap: hasVotedNext
                                  ? () {}
                                  : () => gameNotifier.voteNext(),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            flex: 3,
                            child: ComicButton(
                              label: '⏭️ التالي',
                              color: ComicColors.blue,
                              textColor: Colors.white,
                              onTap: currentQuestionIndex < gameState.questions.length - 1
                                  ? () => gameNotifier.nextQuestionFirestore()
                                  : () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          ComicButton(
                            label: '🏆',
                            color: ComicColors.yellow,
                            onTap: () => _showWinnerSelectionDialog(context, ref),
                            fontSize: 22,
                          ),
                        ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Answer Feedback Overlay
          if (isMultiplayer && roomSession?.lastAnswer != null)
            AnswerFeedbackOverlay(
              playerName: syncedPlayers.firstWhere((p) => p.id == roomSession?.lastAnswerPlayerId, orElse: () => PlayerModel(id: '', name: 'لاعب مجهول', score: 0)).name,
              answer: roomSession!.lastAnswer!,
              isCorrect: roomSession.isLastAnswerCorrect ?? false,
              isBuzzerClaimed: roomSession.buzzerPlayerId != null,
            ),
        ],
      ),
    );
  }

  void _showFinalWinnerDialog(BuildContext context, String winnerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: ComicColors.black, width: 5),
        ),
        title: const Text('🎉 بطل المسابقة! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: ComicColors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 80)).animate().scale(duration: 600.ms).shake(),
            const SizedBox(height: 20),
            Text(
              winnerName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 32, color: ComicColors.blue),
            ),
            const SizedBox(height: 20),
            const Text('مبروك الفوز يا بطل! استعد للمنافسة الجاية.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
        actions: [
          ComicButton(
            label: 'رجوع للرئيسية',
            color: ComicColors.green,
            textColor: Colors.white,
            onTap: () async {
              Navigator.pop(ctx);
              // Leaving an online room cleans it up on the way out.
              if (ref.read(currentRoomIdProvider) != null) {
                await ref.read(roomNotifierProvider.notifier).leaveRoom();
              }
              if (context.mounted) context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}
