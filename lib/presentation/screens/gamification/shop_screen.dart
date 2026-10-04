import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';
import 'package:game_show_app/presentation/providers/gamification_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';
import 'package:game_show_app/presentation/widgets/common/xo_shop_item_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  ShopItemCategory? _selectedCategory;
  final List<ShopItemCategory> _categories = ShopItemCategory.values;

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredItemsProvider);
    final shopAsync = ref.watch(shopItemsProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.purple,
        title: const Text('المتجر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredItemsProvider);
            ref.invalidate(shopItemsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              XoCard(
                padding: const EdgeInsets.all(16),
                backgroundColor: ComicColors.white,
                gradientColors: [
                  ComicColors.yellow.withValues(alpha: 0.25),
                  ComicColors.orange.withValues(alpha: 0.12),
                ],
                borderColor: ComicColors.black,
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: ComicColors.orange, size: 32),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('250', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
                        Text('عملات', style: TextStyle(fontSize: 12, color: ComicColors.grey)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.diamond, color: ComicColors.purple, size: 32),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.purple)),
                        Text('جواهر', style: TextStyle(fontSize: 12, color: ComicColors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'المميز',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ComicColors.black),
              ),
              const SizedBox(height: 8),
              featuredAsync.when(
                loading: () => const XoShimmerLoading(itemCount: 2, itemHeight: 180),
                error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
                data: (items) {
                  if (items.isEmpty) return const XoEmptyState(title: 'لا توجد عناصر مميزة');
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => SizedBox(
                        width: 160,
                        child: ShopItemCard(item: items[index]),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final bool isAll = index == 0;
                    final bool isSelected = isAll ? _selectedCategory == null : _categories[index - 1] == _selectedCategory;
                    final String label = isAll ? 'الكل' : _categoryLabel(_categories[index - 1]);
                    return FilterChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = isAll ? null : _categories[index - 1];
                        });
                      },
                      selectedColor: ComicColors.yellow,
                      checkmarkColor: ComicColors.black,
                      labelStyle: const TextStyle(
                        color: ComicColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      backgroundColor: ComicColors.white,
                      side: const BorderSide(color: ComicColors.black, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              shopAsync.when(
                loading: () => const XoShimmerLoading(itemCount: 4, itemHeight: 200),
                error: (e, _) => XoErrorWidget(message: 'خطأ: $e'),
                data: (items) {
                  final filtered = _selectedCategory == null
                      ? items
                      : items.where((item) => item.category == _selectedCategory).toList();
                  if (filtered.isEmpty) {
                    return const XoEmptyState(title: 'لا توجد عناصر في هذا القسم');
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => ShopItemCard(item: filtered[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.avatars: return 'شخصيات';
      case ShopItemCategory.themes: return 'ثيمات';
      case ShopItemCategory.powerUps: return 'تعزيزات';
      case ShopItemCategory.boosters: return 'معززات';
      case ShopItemCategory.titles: return 'ألقاب';
      case ShopItemCategory.frames: return 'إطارات';
      case ShopItemCategory.bundles: return 'حزم';
    }
  }
}
