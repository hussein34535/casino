import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class XoTimerWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final bool autoStart;
  final double size;
  final Color? color;

  const XoTimerWidget({
    super.key,
    required this.seconds,
    this.onComplete,
    this.autoStart = true,
    this.size = 60,
    this.color,
  });

  @override
  State<XoTimerWidget> createState() => _XoTimerWidgetState();
}

class _XoTimerWidgetState extends State<XoTimerWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  int _remaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );
    if (widget.autoStart) start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void start() {
    _remaining = widget.seconds;
    _controller.duration = Duration(seconds: widget.seconds);
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _remaining--);
      if (_remaining <= 0) {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  void reset() {
    _timer?.cancel();
    setState(() => _remaining = widget.seconds);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? _getColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 4,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  _remaining.toString(),
                  style: TextStyle(
                    fontSize: widget.size * 0.35,
                    fontWeight: FontWeight.w900,
                    color: ComicColors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColor() {
    final ratio = _remaining / widget.seconds;
    if (ratio > 0.5) return ComicColors.green;
    if (ratio > 0.25) return ComicColors.orange;
    return ComicColors.red;
  }
}
