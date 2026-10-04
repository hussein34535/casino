import 'package:flutter/material.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItemModel item;
  final VoidCallback? onBuy;
  final bool canAfford;

  const ShopItemCard({
    super.key,
    required this.item,
    this.onBuy,
    this.canAfford = true,
  });

  @override
  Widget build(BuildContext context) {
    return XoCard(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.zero,
      backgroundColor: ComicColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ComicColors.cream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ComicColors.black, width: 2),
                ),
                child: Icon(
                  _iconForCategory(item.category),
                  size: 40,
                  color: ComicColors.grey,
                ),
              ),
              if (item.discountPercent > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ComicColors.red,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ComicColors.black, width: 1.5),
                    ),
                    child: Text(
                      '-${item.discountPercent}%',
                      style: const TextStyle(
                        color: ComicColors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              if (item.isLimited)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ComicColors.yellow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ComicColors.black, width: 1.5),
                    ),
                    child: const Text(
                      'محدود',
                      style: TextStyle(
                        color: ComicColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.name['ar'] ?? item.name['en'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: ComicColors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.description['ar'] ?? item.description['en'] ?? '',
            style: const TextStyle(fontSize: 11, color: ComicColors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                item.currency == 'gems' ? Icons.diamond : Icons.monetization_on,
                size: 16,
                color: item.currency == 'gems' ? ComicColors.purple : ComicColors.orange,
              ),
              const SizedBox(width: 4),
              if (item.discountPercent > 0)
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    color: ComicColors.grey,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                '${item.discountedPrice ?? item.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: ComicColors.black,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford ? ComicColors.yellow : ComicColors.grey,
                    foregroundColor: ComicColors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: ComicColors.black, width: 2),
                    ),
                  ),
                  child: Text(canAfford ? 'شراء' : 'غير متاح'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.avatars:
        return Icons.face;
      case ShopItemCategory.themes:
        return Icons.palette;
      case ShopItemCategory.powerUps:
        return Icons.bolt;
      case ShopItemCategory.boosters:
        return Icons.trending_up;
      case ShopItemCategory.titles:
        return Icons.badge;
      case ShopItemCategory.frames:
        return Icons.filter_frames;
      case ShopItemCategory.bundles:
        return Icons.inventory_2;
    }
  }
}
