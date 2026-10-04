import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/level_reward_model.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';
import 'package:game_show_app/presentation/providers/gamification_provider.dart';
import 'package:game_show_app/services/gamification/shop_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockShopService extends ShopService {
  MockShopService() : super(MockFirebaseFirestore());

  List<ShopItemModel> items = [];

  @override
  Future<List<ShopItemModel>> getShopItems() async => items;

  @override
  Future<List<ShopItemModel>> getFeaturedItems() async {
    return (await getShopItems()).where((i) => i.isFeatured).toList();
  }

  @override
  Future<List<ShopItemModel>> getDiscountedItems() async {
    return (await getShopItems()).where((i) => i.discountPercent > 0).toList();
  }

  @override
  Future<bool> purchaseItem(String userId, String itemId) async => true;
}

void main() {
  group('levelingServiceProvider', () {
    test('provides a LevelingService instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      expect(service, isNotNull);
    });

    test('calculateLevel returns correct level based on XP', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      expect(service.calculateLevel(0), 1);
      expect(service.calculateLevel(50), 1);
      expect(service.calculateLevel(100), 2);
      expect(service.calculateLevel(250), 3);
      expect(service.calculateLevel(500), 6);
    });

    test('getTotalXpForLevel returns cumulative XP for a level', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      expect(service.getTotalXpForLevel(1), 0);
      expect(service.getTotalXpForLevel(2), 100);
      expect(service.getTotalXpForLevel(5), 400);
      expect(service.getTotalXpForLevel(10), 900);
    });

    test('getXpForNextLevel returns remaining XP needed', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      expect(service.getXpForNextLevel(0), 100);
      expect(service.getXpForNextLevel(50), 50);
      expect(service.getXpForNextLevel(100), 100);
      expect(service.getXpForNextLevel(250), 50);
    });

    test('getLevelRewards returns rewards at milestone levels', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      final rewards = service.getLevelRewards(10);
      expect(rewards.length, 1);
      expect(rewards[0].level, 10);
      expect(rewards[0].amount, 500);
      expect(rewards[0].type, LevelRewardType.coins);
    });

    test('getLevelRewards returns empty for non-milestone levels', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      expect(service.getLevelRewards(3), isEmpty);
      expect(service.getLevelRewards(7), isEmpty);
      expect(service.getLevelRewards(11), isEmpty);
    });

    test('getLevelRewards returns reward for level 50 (max milestone)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(levelingServiceProvider);
      final rewards = service.getLevelRewards(50);
      expect(rewards.length, 1);
      expect(rewards[0].level, 50);
      expect(rewards[0].type, LevelRewardType.badge);
    });
  });

  group('featuredItemsProvider', () {
    test('returns only items where isFeatured is true', () async {
      final mockShop = MockShopService();
      mockShop.items = [
        ShopItemModel(
          id: '1',
          name: {'en': 'Featured Avatar'},
          category: ShopItemCategory.avatars,
          isFeatured: true,
        ),
        ShopItemModel(
          id: '2',
          name: {'en': 'Regular Theme'},
          category: ShopItemCategory.themes,
          isFeatured: false,
        ),
        ShopItemModel(
          id: '3',
          name: {'en': 'Featured Title'},
          category: ShopItemCategory.titles,
          isFeatured: true,
        ),
      ];

      final container = ProviderContainer(overrides: [
        shopServiceProvider.overrideWithValue(mockShop),
      ]);
      addTearDown(container.dispose);

      final items = await container.read(featuredItemsProvider.future);
      expect(items.length, 2);
      expect(items.every((i) => i.isFeatured), true);
      expect(items.map((i) => i.id).toSet(), {'1', '3'});
    });

    test('returns empty list when no items are featured', () async {
      final mockShop = MockShopService();
      mockShop.items = [
        ShopItemModel(
          id: '1',
          name: {'en': 'Regular Item'},
          category: ShopItemCategory.avatars,
        ),
      ];

      final container = ProviderContainer(overrides: [
        shopServiceProvider.overrideWithValue(mockShop),
      ]);
      addTearDown(container.dispose);

      final items = await container.read(featuredItemsProvider.future);
      expect(items, isEmpty);
    });

    test('returns empty list when shop has no items', () async {
      final mockShop = MockShopService();
      mockShop.items = [];

      final container = ProviderContainer(overrides: [
        shopServiceProvider.overrideWithValue(mockShop),
      ]);
      addTearDown(container.dispose);

      final items = await container.read(featuredItemsProvider.future);
      expect(items, isEmpty);
    });
  });

  group('discountedItemsProvider', () {
    test('returns only items with discountPercent > 0', () async {
      final mockShop = MockShopService();
      mockShop.items = [
        ShopItemModel(
          id: '1',
          name: {'en': 'Discounted Item'},
          category: ShopItemCategory.avatars,
          discountPercent: 25,
        ),
        ShopItemModel(
          id: '2',
          name: {'en': 'Full Price Item'},
          category: ShopItemCategory.themes,
          discountPercent: 0,
        ),
        ShopItemModel(
          id: '3',
          name: {'en': 'On Sale Frame'},
          category: ShopItemCategory.frames,
          discountPercent: 10,
        ),
      ];

      final container = ProviderContainer(overrides: [
        shopServiceProvider.overrideWithValue(mockShop),
      ]);
      addTearDown(container.dispose);

      final items = await container.read(discountedItemsProvider.future);
      expect(items.length, 2);
      expect(items.every((i) => i.discountPercent > 0), true);
    });
  });
}
