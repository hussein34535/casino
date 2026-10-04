import 'package:flutter/material.dart';

class XoAnimatedFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool autoFlip;
  final Duration flipDuration;
  final Duration? autoFlipInterval;
  final bool initiallyFlipped;

  const XoAnimatedFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.autoFlip = false,
    this.flipDuration = const Duration(milliseconds: 600),
    this.autoFlipInterval,
    this.initiallyFlipped = false,
  });

  @override
  State<XoAnimatedFlipCard> createState() => _XoAnimatedFlipCardState();
}

class _XoAnimatedFlipCardState extends State<XoAnimatedFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _isFlipped = widget.initiallyFlipped;
    _controller = AnimationController(
      vsync: this,
      duration: widget.flipDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.initiallyFlipped) {
      _controller.value = 1;
    }
    if (widget.autoFlip && widget.autoFlipInterval != null) {
      _startAutoFlip();
    }
  }

  void _startAutoFlip() {
    Future.delayed(widget.autoFlipInterval!, () {
      if (mounted) {
        flip();
        _startAutoFlip();
      }
    });
  }

  void flip() {
    if (_controller.isAnimating) return;
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.autoFlip ? null : flip,
      child: ListenableBuilder(
        listenable: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14159265;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: angle < 3.14159265 / 2
                ? _buildFront(angle)
                : _buildBack(angle),
          );
        },
      ),
    );
  }

  Widget _buildFront(double angle) {
    return Opacity(
      opacity: (1 - _animation.value).clamp(0, 1),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(-angle),
        child: widget.front,
      ),
    );
  }

  Widget _buildBack(double angle) {
    return Opacity(
      opacity: (_animation.value - 0.5).clamp(0, 1) * 2,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(3.14159265 - angle),
        child: widget.back,
      ),
    );
  }
}
