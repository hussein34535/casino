import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_show_app/core/design/xo_design.dart';
import 'package:game_show_app/core/design/xo_icon.dart';

/// Dark premium scaffold: navy gradient + two static ambient glows.
/// Glows are pre-built (no animation) so the screen stays at 60fps.
class XoScaffold extends StatelessWidget {
  final String title;
  final String titleIcon;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;

  const XoScaffold({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.body,
    this.actions,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XoDesign.navy900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              )
            : null,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: XoDesign.goldGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: XoIcon(titleIcon, color: XoDesign.navy900, size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: XoDesign.h2.copyWith(color: Colors.white)),
            ),
          ],
        ),
        actions: actions,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: XoDesign.bgGradient),
        child: Stack(
          children: [
            // Static ambient glows (cheap: no repaint, no animation).
            Positioned(
              top: -90,
              right: -70,
              child: _Glow(size: 260, color: XoDesign.indigo.withValues(alpha: 0.28)),
            ),
            Positioned(
              bottom: -110,
              left: -80,
              child: _Glow(size: 300, color: XoDesign.gold.withValues(alpha: 0.10)),
            ),
            SafeArea(child: body),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

/// White premium card with soft shadow.
class XoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color color;

  const XoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.color = XoDesign.card,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: XoDesign.radiusAll,
        boxShadow: XoDesign.softShadow(),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: XoDesign.radiusAll,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: card,
      ),
    );
  }
}

/// Frosted glass card for secondary content on dark backgrounds.
class XoGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const XoGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: XoDesign.glass,
        borderRadius: XoDesign.radiusAll,
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: XoDesign.radiusAll,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: card,
      ),
    );
  }
}

/// Gradient CTA button with optional icon + loading state.
class XoButton extends StatelessWidget {
  final String label;
  final String? icon;
  final VoidCallback? onTap;
  final bool loading;
  final Gradient gradient;
  final Color foreground;

  const XoButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.loading = false,
    this.gradient = XoDesign.goldGradient,
    this.foreground = XoDesign.navy900,
  });

  const XoButton.indigo({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.loading = false,
  })  : gradient = XoDesign.indigoGradient,
        foreground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !loading;
    final iconName = icon;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled ? XoDesign.glowShadow(XoDesign.gold.withValues(alpha: 0.5)) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: enabled
                ? () {
                    HapticFeedback.mediumImpact();
                    onTap!();
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (loading)
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 3, color: foreground),
                    )
                  else ...[
                    if (iconName != null) ...[
                      XoIcon(iconName, color: foreground, size: 22),
                      const SizedBox(width: 10),
                    ],
                    Text(label,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900, color: foreground)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill section header with icon.
class XoSectionHeader extends StatelessWidget {
  final String icon;
  final String title;
  final Color iconColor;

  const XoSectionHeader({super.key, required this.icon, required this.title, this.iconColor = XoDesign.gold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        XoIcon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: XoDesign.h2.copyWith(color: XoDesign.ink)),
      ],
    );
  }
}

/// Circular avatar with photo-or-initial fallback.
class XoAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;
  final Color background;

  const XoAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.size = 48,
    this.background = XoDesign.indigo,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: background,
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null
          ? Text(
              name.isNotEmpty ? name.characters.first : '?',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900, fontSize: size * 0.4),
            )
          : null,
    );
  }
}

/// Six-box room code input with auto-advance + paste distribution.
class XoCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final VoidCallback? onChanged;

  const XoCodeInput({super.key, required this.onCompleted, this.onChanged});

  @override
  State<XoCodeInput> createState() => XoCodeInputState();
}

class XoCodeInputState extends State<XoCodeInput> {
  static const int length = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _nodes = List.generate(length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get code => _controllers.map((c) => c.text).join();

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _nodes.first.requestFocus();
    setState(() {});
  }

  void _onChanged(String value, int index) {
    // Paste: distribute across boxes.
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'\s'), '').split('');
      for (var i = 0; i < length; i++) {
        _controllers[i].text = i < chars.length ? chars[i] : '';
      }
      _nodes.last.requestFocus();
    } else if (value.isNotEmpty && index < length - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    widget.onChanged?.call();
    if (code.length == length) {
      _nodes[index].unfocus();
      widget.onCompleted(code);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(length, (i) {
          final filled = _controllers[i].text.isNotEmpty;
          return SizedBox(
            width: 46,
            height: 56,
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              autofocus: i == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6, // allows paste of full code
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900, color: XoDesign.ink),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: filled ? XoDesign.gold.withValues(alpha: 0.15) : const Color(0xFFF1F2F7),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XoDesign.radiusXs),
                  borderSide: BorderSide(
                      color: filled ? XoDesign.goldDeep : const Color(0xFFE2E4EF), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XoDesign.radiusXs),
                  borderSide: const BorderSide(color: XoDesign.indigo, width: 2),
                ),
              ),
              onChanged: (v) => _onChanged(v, i),
            ),
          );
        }),
      ),
    );
  }
}

/// Consistent snackbar styling.
void showXoSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
      backgroundColor: error ? XoDesign.rose : XoDesign.mint,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 2),
    ),
  );
}
