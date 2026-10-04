import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';

void main() {
  group('ShopItemModel', () {
    group('ShopItemCategory enum', () {
      test('has all expected values', () {
        expect(ShopItemCategory.values.length, 7);
        expect(ShopItemCategory.values, contains(ShopItemCategory.avatars));
        expect(ShopItemCategory.values, contains(ShopItemCategory.themes));
        expect(ShopItemCategory.values, contains(ShopItemCategory.powerUps));
        expect(ShopItemCategory.values, contains(ShopItemCategory.boosters));
        expect(ShopItemCategory.values, contains(ShopItemCategory.titles));
        expect(ShopItemCategory.values, contains(ShopItemCategory.frames));
        expect(ShopItemCategory.values, contains(ShopItemCategory.bundles));
      });

      test('avatars is the default fallback', () {
        final item = ShopItemModel.fromJson({});
        expect(item.category, ShopItemCategory.avatars);
      });
    });

    final testJson = {
      'id': 'item1',
      'name': {'ar': 'منتج', 'en': 'Item'},
      'description': {'ar': 'وصف', 'en': 'Description'},
      'category': 'themes',
      'price': 500,
      'currency': 'coins',
      'discountedPrice': 400,
      'levelRequirement': 5,
      'priceCoins': 500,
      'priceGems': 100,
      'discountPercent': 20,
      'itemType': 'theme',
      'itemId': 'dark_theme',
      'imageUrl': 'https://example.com/item.png',
      'isFeatured': true,
      'isLimited': false,
    };

    test('fromJson creates model correctly', () {
      final item = ShopItemModel.fromJson(testJson);
      expect(item.id, 'item1');
      expect(item.category, ShopItemCategory.themes);
      expect(item.price, 500);
      expect(item.currency, 'coins');
      expect(item.discountedPrice, 400);
      expect(item.levelRequirement, 5);
      expect(item.priceCoins, 500);
      expect(item.priceGems, 100);
      expect(item.discountPercent, 20);
      expect(item.itemType, 'theme');
      expect(item.itemId, 'dark_theme');
      expect(item.imageUrl, 'https://example.com/item.png');
      expect(item.isFeatured, true);
      expect(item.isLimited, false);
    });

    test('toJson produces correct map', () {
      final item = ShopItemModel.fromJson(testJson);
      final json = item.toJson();
      expect(json['id'], 'item1');
      expect(json['category'], 'themes');
      expect(json['price'], 500);
      expect(json['currency'], 'coins');
      expect(json['isFeatured'], true);
    });

    test('fromJson uses default values for missing fields', () {
      final item = ShopItemModel.fromJson({});
      expect(item.id, '');
      expect(item.category, ShopItemCategory.avatars);
      expect(item.price, 0);
      expect(item.currency, 'coins');
      expect(item.discountedPrice, isNull);
      expect(item.levelRequirement, 0);
      expect(item.priceCoins, 0);
      expect(item.priceGems, 0);
      expect(item.discountPercent, 0);
      expect(item.isFeatured, false);
      expect(item.isLimited, false);
    });

    group('discountedCoins', () {
      test('returns priceCoins when discountPercent is 0', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceCoins: 500,
          discountPercent: 0,
        );
        expect(item.discountedCoins, 500);
      });

      test('applies discount correctly', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceCoins: 1000,
          discountPercent: 25,
        );
        expect(item.discountedCoins, 750);
      });

      test('returns priceCoins when discountPercent negative', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceCoins: 500,
          discountPercent: -10,
        );
        expect(item.discountedCoins, 500);
      });
    });

    group('discountedGems', () {
      test('returns priceGems when discountPercent is 0', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceGems: 200,
          discountPercent: 0,
        );
        expect(item.discountedGems, 200);
      });

      test('applies discount correctly', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceGems: 500,
          discountPercent: 30,
        );
        expect(item.discountedGems, 350);
      });

      test('returns priceGems when discountPercent negative', () {
        final item = ShopItemModel(
          id: 'item1',
          category: ShopItemCategory.avatars,
          priceGems: 200,
          discountPercent: -10,
        );
        expect(item.discountedGems, 200);
      });
    });

    test('constructor sets default localized strings', () {
      final item = ShopItemModel(
        id: 'item1',
        category: ShopItemCategory.avatars,
      );
      expect(item.name, {'ar': 'منتج', 'en': 'Item'});
      expect(item.description, {'ar': 'منتج في المتجر', 'en': 'Shop item'});
    });
  });
}
