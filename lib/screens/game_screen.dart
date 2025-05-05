import 'package:flutter/material.dart';
import 'package:game_show_app/models/game_type.dart';
import 'package:game_show_app/providers/game_provider.dart';
import 'package:game_show_app/screens/results_screen.dart';
import 'package:game_show_app/screens/game_select_screen.dart';
import 'package:game_show_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:game_show_app/models/question.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:game_show_app/models/player.dart'; // Import Player model

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late AudioPlayer _audioPlayer;
  String? _currentAudioUrl;
  bool _audioLoadError = false;
  late List<GlobalKey> _playerCardKeys;
  int? _longPressedPlayerIndex;
  OverlayEntry? _overlayEntry;
  bool _playerCardKeysInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        if (mounted) setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        if (!_playerCardKeysInitialized ||
            _playerCardKeys.length != gameProvider.players.length) {
          setState(() {
            _playerCardKeys =
                List.generate(gameProvider.players.length, (_) => GlobalKey());
            _playerCardKeysInitialized = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_longPressedPlayerIndex != null && mounted) {
      setState(() {
        _longPressedPlayerIndex = null;
      });
    }
  }

  void _showCardOverlay(BuildContext context, GameProvider gameProvider,
      int playerIndex, GlobalKey itemKey, Player player) {
    _removeOverlay();
    HapticFeedback.mediumImpact();

    if (mounted) {
      setState(() {
        _longPressedPlayerIndex = playerIndex;
      });
    }

    final RenderObject? renderObject =
        itemKey.currentContext?.findRenderObject();
    final NavigatorState? navigator =
        Navigator.of(context, rootNavigator: true);

    if (renderObject is! RenderBox || navigator?.overlay == null) {
      print("Error: Could not find RenderBox or Overlay for player card.");
      if (mounted) {
        setState(() {
          _longPressedPlayerIndex = null;
        });
      }
      return;
    }
    final RenderBox renderBox = renderObject;
    final cardSize = renderBox.size;
    final cardPosition = renderBox.localToGlobal(Offset.zero,
        ancestor: navigator!.overlay?.context.findRenderObject());

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final double menuWidthEstimate = 110.0;
        final double menuVerticalOffset = 60.0;
        final double menuTop = cardPosition.dy - menuVerticalOffset;
        final double menuLeft =
            cardPosition.dx + (cardSize.width / 2) - (menuWidthEstimate / 2);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              top: cardPosition.dy,
              left: cardPosition.dx,
              child: IgnorePointer(
                child: SizedBox(
                  width: cardSize.width,
                  height: cardSize.height,
                  child: _buildPlayerCardVisuals(
                      context, gameProvider, player, playerIndex, true),
                ),
              ),
            ),
            Positioned(
              top: menuTop,
              left: menuLeft,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(
                    milliseconds: 450), // Slightly longer for elastic
                curve: Curves.elasticOut, // Use elastic curve for bounce
                builder: (context, value, child) {
                  final matrix = Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Add perspective
                    ..rotateX(-pi /
                        2 *
                        (1 - value)); // Rotate from -90deg to 0deg on X-axis

                  return Transform(
                    transform: matrix,
                    alignment: FractionalOffset
                        .center, // Keep centered during transform
                    child: Transform.scale(
                      scale: value, // Keep existing scale animation
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _buildHorizontalCardMenu(
                    context, gameProvider, playerIndex),
              ),
            ),
          ],
        );
      },
    );

    // Insert the overlay
    navigator.overlay?.insert(_overlayEntry!);
  }

  Widget _buildHorizontalCardMenu(
      BuildContext context, GameProvider gameProvider, int playerIndex) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              )
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.square_rounded,
                  color: Colors.yellow.shade700, size: 28),
              tooltip: 'كرت أصفر (-1)',
              onPressed: () {
                gameProvider.giveYellowCard(playerIndex);
                _removeOverlay();
              },
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.square_rounded,
                  color: Colors.red.shade700, size: 28),
              tooltip: 'كرت أحمر (-3)',
              onPressed: () {
                gameProvider.giveRedCard(playerIndex);
                _removeOverlay();
              },
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCardVisuals(
      BuildContext context,
      GameProvider gameProvider,
      Player player,
      int index,
      bool isHighlightedInOverlay) {
    final theme = Theme.of(context);
    // Determine score color based on value (3 conditions)
    final Color scoreColor;
    if (player.score >= 10) {
      scoreColor = Colors.green; // Green if score >= 10
    } else if (player.score > 0) {
      scoreColor = Colors.white; // White if score > 0 and < 10
    } else {
      scoreColor = theme.colorScheme.error; // Red if score <= 0
    }

    // Define button color
    final Color buttonColor = Colors.grey.shade600; // Grey color for buttons

    return Material(
      elevation: isHighlightedInOverlay ? 16.0 : 3.0,
      shadowColor: isHighlightedInOverlay
          ? Colors.black.withOpacity(0.6)
          : Colors.black.withOpacity(0.2),
      color: theme.cardColor,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _buildPlayerCardRowContent(
            context, gameProvider, player, index, true),
      ),
    );
  }

  Widget _buildPlayerCardRowContent(BuildContext context,
      GameProvider gameProvider, Player player, int index, bool isVisualCopy) {
    final theme = Theme.of(context);
    final Color scoreColor;
    if (player.score >= 10) {
      scoreColor = Colors.green;
    } else if (player.score > 0) {
      scoreColor = Colors.white;
    } else {
      scoreColor = theme.colorScheme.error;
    }
    final Color buttonColor = Colors.grey.shade600;

    return Row(
      children: <Widget>[
        Icon(Icons.person_outline,
            color: theme.iconTheme.color?.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            player.name,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        if (player.yellowCards > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.square_rounded,
                  color: Colors.yellow.shade700, size: 20),
              if (player.yellowCards > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text('${player.yellowCards}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade900)),
                ),
              const SizedBox(width: 5),
            ],
          ),
        if (player.redCards > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.square_rounded, color: Colors.red.shade700, size: 20),
              if (player.redCards > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text('${player.redCards}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900)),
                ),
            ],
          ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: buttonColor,
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إنقاص نقطة',
              splashRadius: 20,
              onPressed: isVisualCopy
                  ? null
                  : () {
                      _removeOverlay();
                      gameProvider.updateScore(index, -1);
                    },
            ),
            const SizedBox(width: 8),
            Text(
              '${player.score}',
              style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: scoreColor, fontSize: 20),
              textAlign: TextAlign.center,
            )
                .animate(
                    key: ValueKey('${player.name}-${player.score}'),
                    target: isVisualCopy ? 0 : 1)
                .shake(hz: 3, duration: 300.ms),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: buttonColor,
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'زيادة نقطة',
              splashRadius: 20,
              onPressed: isVisualCopy
                  ? null
                  : () {
                      _removeOverlay();
                      gameProvider.updateScore(index, 1);
                    },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    _removeOverlay();
    await _audioPlayer.stop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameSelectScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Ensure keys are initialized or updated if player list changes
    if (!_playerCardKeysInitialized ||
        _playerCardKeys.length != gameProvider.players.length) {
      _playerCardKeys =
          List.generate(gameProvider.players.length, (_) => GlobalKey());
      _playerCardKeysInitialized = true;
      _longPressedPlayerIndex = null;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'جولة: ${gameProvider.selectedGameType != null ? getGameTypeNameAr(gameProvider.selectedGameType!) : 'لعبة غير محددة'}'),
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Theme.of(context)
                          .inputDecorationTheme
                          .enabledBorder
                          ?.borderSide
                          .color ??
                      Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () async {
                  _removeOverlay();
                  await _audioPlayer.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const GameSelectScreen(isChangingType: true)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("تغيير النوع", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      const Icon(Icons.category_outlined, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            // Define the main content Column structure
            Widget mainColumn = Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildQuestionArea(context, gameProvider.currentQuestion),
                  const SizedBox(height: 20.0),
                  // Conditional layout for player list based on orientation
                  if (orientation == Orientation.portrait)
                    Expanded(
                      // Portrait: Use Expanded, no shrinkWrap for ListView
                      child: _buildPlayerList(context, gameProvider,
                          useShrinkWrap: false),
                    )
                  else // Landscape
                    // Landscape: No Expanded, use shrinkWrap for ListView
                    _buildPlayerList(context, gameProvider,
                        useShrinkWrap: true),

                  const SizedBox(height: 20.0),
                  _buildControlButtons(context, gameProvider),
                ],
              ),
            );

            // Wrap with SingleChildScrollView ONLY in landscape mode
            if (orientation == Orientation.landscape) {
              return SingleChildScrollView(
                child: mainColumn,
              );
            } else {
              // In portrait mode, return the Column directly (no scrolling wrapper needed)
              return mainColumn;
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuestionArea(BuildContext context, Question? currentQuestion) {
    bool isMusicQuestion = currentQuestion?.type == GameType.music &&
        currentQuestion?.audioUrl != null;
    final newAudioUrl = currentQuestion?.audioUrl;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (isMusicQuestion &&
          newAudioUrl != null &&
          newAudioUrl != _currentAudioUrl) {
        _currentAudioUrl = newAudioUrl;
        if (mounted) {
          setState(() {
            _audioLoadError = false;
          });
        }
        _audioPlayer.stop().then((_) {
          if (!mounted) return;
          _audioPlayer.setUrl(_currentAudioUrl!).catchError((error) {
            print("Error loading audio: $error");
            if (mounted) {
              setState(() {
                _audioLoadError = true;
              });
            }
          });
        });
      } else if (!isMusicQuestion && _currentAudioUrl != null) {
        _audioPlayer.stop();
        if (mounted) {
          setState(() {
            _currentAudioUrl = null;
            _audioLoadError = false;
          });
        }
      }
    });

    String displayText = currentQuestion?.text ?? 'انتهت الأسئلة!';
    String? answerText = currentQuestion?.answer;

    if (currentQuestion?.type == GameType.words &&
        currentQuestion?.text != null &&
        currentQuestion!.text!.isNotEmpty) {
      String originalWord = currentQuestion.text!;
      String reversedWord = originalWord.split('').reversed.join('');
      displayText = reversedWord.split('').join(' ');
      answerText = originalWord;
    }

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isMusicQuestion)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _audioLoadError
                          ? Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 50.0,
                            )
                          : StreamBuilder<PlayerState>(
                              stream: _audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final playing = playerState?.playing ?? false;

                                IconData iconData;
                                VoidCallback? onPressedAction;

                                bool buttonEnabled = processingState !=
                                        ProcessingState.loading &&
                                    processingState !=
                                        ProcessingState.buffering &&
                                    processingState !=
                                        ProcessingState.completed;

                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  iconData = Icons.hourglass_empty;
                                } else if (!playing) {
                                  iconData = Icons.play_arrow;
                                  onPressedAction = _audioPlayer.play;
                                } else {
                                  iconData = Icons.pause;
                                  onPressedAction = _audioPlayer.pause;
                                }

                                return IconButton(
                                  icon: Icon(iconData),
                                  iconSize: 50.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed:
                                      buttonEnabled ? onPressedAction : null,
                                );
                              },
                            ),
                      const SizedBox(height: 5),
                      StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          final duration =
                              positionData?.duration ?? Duration.zero;
                          final position =
                              positionData?.position ?? Duration.zero;

                          if (duration > Duration.zero && !_audioLoadError) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Slider(
                                  min: 0.0,
                                  max: duration.inMilliseconds.toDouble(),
                                  value: min(position.inMilliseconds.toDouble(),
                                      duration.inMilliseconds.toDouble()),
                                  onChanged: (value) {
                                    _audioPlayer.seek(
                                        Duration(milliseconds: value.round()));
                                  },
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  inactiveColor: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.5) ??
                                      Colors.grey.withOpacity(0.5),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(position),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      Text(_formatDuration(duration),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox(height: 40);
                          }
                        },
                      ),
                    ],
                  ),
                if (isMusicQuestion) const SizedBox(height: 15),
                Stack(
                  children: [
                    Text(
                      displayText,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                height: 1.5,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = Theme.of(context)
                                          .elevatedButtonTheme
                                          .style
                                          ?.foregroundColor
                                          ?.resolve({}) ??
                                      Colors.black87,
                              ),
                    ),
                    Text(
                      displayText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              height: 1.5,
                              color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                if (answerText != null && answerText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'الإجابة: $answerText',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerList(BuildContext context, GameProvider gameProvider,
      {required bool useShrinkWrap}) {
    final players = gameProvider.players;
    final theme = Theme.of(context);

    if (_playerCardKeys.length != players.length) {
      print("Warning: Player key list length mismatch. Re-initializing.");
      _playerCardKeys = List.generate(players.length, (_) => GlobalKey());
      _playerCardKeysInitialized = true;
    }

    if (players.isEmpty) {
      return const Center(child: Text('لم يتم إضافة لاعبين بعد.'));
    }

    return ListView.builder(
      shrinkWrap: useShrinkWrap,
      physics: useShrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final key = (index < _playerCardKeys.length)
            ? _playerCardKeys[index]
            : GlobalKey();
        final bool isCurrentlyLongPressed = _longPressedPlayerIndex == index;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
          child: Opacity(
            opacity: isCurrentlyLongPressed ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: isCurrentlyLongPressed,
              child: InkWell(
                key: key,
                onLongPress: () {
                  _showCardOverlay(context, gameProvider, index, key, player);
                },
                onTap: _removeOverlay,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Material(
                  elevation: 3.0,
                  shadowColor: Colors.black.withOpacity(0.2),
                  color: theme.cardColor,
                  shape: theme.cardTheme.shape ??
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: _buildPlayerCardRowContent(
                        context, gameProvider, player, index, false),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(BuildContext context, GameProvider gameProvider) {
    final theme = Theme.of(context);
    final bool canNext =
        gameProvider.currentQuestionIndex < gameProvider.questions.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_forward),
          label: const Text('السؤال التالي'),
          onPressed: canNext
              ? () async {
                  _removeOverlay();
                  await _audioPlayer.stop();
                  gameProvider.nextQuestion();
                }
              : null,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.flag_circle_outlined),
          label: const Text('إنهاء وعرض النتائج'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
          ).copyWith(
            shape: theme.elevatedButtonTheme.style?.shape,
          ),
          onPressed: () async {
            _removeOverlay();
            await _audioPlayer.stop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultsScreen()),
            );
          },
        ),
      ],
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
