import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/widgets/common/xo_gradient_container.dart';
import 'package:cached_network_image/cached_network_image.dart';

class XoCategoryCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final String? imageUrl;
  final String? badgeText;
  final Color? badgeColor;
  final double height;
  final double width;

  const XoCategoryCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.onTap,
    this.imageUrl,
    this.badgeText,
    this.badgeColor,
    this.height = 120,
    this.width = double.infinity,
  });

  const XoCategoryCard.small({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.onTap,
    this.badgeText,
    this.badgeColor,
  }) : subtitle = null,
       imageUrl = null,
       height = 80,
       width = double.infinity;

  @override
  Widget build(BuildContext context) {
    return XoGradientContainer(
      colors: gradientColors,
      borderRadius: 16,
      width: width,
      height: height,
      onTap: onTap,
      child: Stack(
        children: [
          if (imageUrl != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(),
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(icon, color: ComicColors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: ComicColors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor ?? ComicColors.yellow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ComicColors.black, width: 2),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: badgeColor != null ? ComicColors.white : ComicColors.black,
                          ),
                        ),
                      ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: ComicColors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
