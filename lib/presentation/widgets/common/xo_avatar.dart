import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class XoAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final bool showBorder;
  final bool isOnline;
  final double borderWidth;

  const XoAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.backgroundColor,
    this.showBorder = false,
    this.isOnline = false,
    this.borderWidth = 2,
  });

  const XoAvatar.small({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 32,
    this.backgroundColor,
    this.showBorder = false,
    this.isOnline = false,
    this.borderWidth = 1.5,
  });

  const XoAvatar.large({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 80,
    this.backgroundColor,
    this.showBorder = false,
    this.isOnline = false,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: showBorder
                ? Border.all(color: ComicColors.black, width: borderWidth)
                : null,
            boxShadow: showBorder
                ? const [BoxShadow(color: ComicColors.black, blurRadius: 0, offset: Offset(3, 3))]
                : null,
          ),
          child: CircleAvatar(
            radius: size / 2,
            backgroundColor: backgroundColor ?? ComicColors.purple,
            backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl!) : null,
            child: imageUrl == null
                ? Text(
                    name?.isNotEmpty == true ? name![0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w900,
                      color: ComicColors.white,
                    ),
                  )
                : null,
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ComicColors.green,
                border: Border.fromBorderSide(BorderSide(color: ComicColors.black, width: 2)),
              ),
            ),
          ),
      ],
    );
  }
}
