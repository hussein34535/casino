import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/data/models/gamification/shop_item_model.dart';

class ShopService {
  final FirebaseFirestore _db;

  ShopService(this._db);

  Future<List<ShopItemModel>> getShopItems() async {
    final snapshot = await _db.collection('shopItems')
        .where('isAvailable', isEqualTo: true)
        .get();
    if (snapshot.docs.isEmpty) return _generateDefaultItems();
    return snapshot.docs.map((d) => ShopItemModel.fromJson(d.data())).toList();
  }

  Future<List<ShopItemModel>> getFeaturedItems() async {
    final items = await getShopItems();
    return items.where((i) => i.isFeatured).toList();
  }

  Future<List<ShopItemModel>> getDiscountedItems() async {
    final items = await getShopItems();
    return items.where((i) => i.discountPercent > 0).toList();
  }

  Future<bool> purchaseItem(String userId, String itemId) async {
    try {
      await _db.collection('userInventory').add({
        'userId': userId,
        'itemId': itemId,
        'purchasedAt': FieldValue.serverTimestamp(),
        'equipped': false,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  List<ShopItemModel> _generateDefaultItems() {
    return [
      ShopItemModel(id: 'avatar_cool', name: {'ar': 'شخصية رائعة', 'en': 'Cool Avatar'}, description: {'ar': 'شخصية حصرية للمحترفين', 'en': 'Exclusive pro avatar'}, category: ShopItemCategory.avatars, priceCoins: 500, isFeatured: true),
      ShopItemModel(id: 'theme_dark_gold', name: {'ar': 'ثيم ذهبي', 'en': 'Gold Theme'}, description: {'ar': 'ثيم داكن مع لمسات ذهبية', 'en': 'Dark theme with gold accents'}, category: ShopItemCategory.themes, priceCoins: 300),
      ShopItemModel(id: 'title_expert', name: {'ar': 'لقب خبير', 'en': 'Expert Title'}, description: {'ar': 'لقب يظهر في لوحة المتصدرين', 'en': 'Title displayed on leaderboard'}, category: ShopItemCategory.titles, priceCoins: 200, priceGems: 50, isFeatured: true, discountPercent: 25),
      ShopItemModel(id: 'boost_x2', name: {'ar': 'مضاعف نقاط x2', 'en': '2x Points Boost'}, description: {'ar': 'ضعف النقاط في اللعبة القادمة', 'en': 'Double points in next game'}, category: ShopItemCategory.powerUps, priceCoins: 100, isLimited: true),
      ShopItemModel(id: 'avatar_rare', name: {'ar': 'شخصية نادرة', 'en': 'Rare Avatar'}, description: {'ar': 'شخصية محدودة الإصدار', 'en': 'Limited edition avatar'}, category: ShopItemCategory.avatars, priceCoins: 1000, priceGems: 200, isFeatured: true, isLimited: true),
      ShopItemModel(id: 'theme_neon', name: {'ar': 'ثيم نيـون', 'en': 'Neon Theme'}, description: {'ar': 'ثيم مستقبلي بألوان النيون', 'en': 'Futuristic neon-colored theme'}, category: ShopItemCategory.themes, priceCoins: 400),
      ShopItemModel(id: 'title_legend', name: {'ar': 'لقب أسطورة', 'en': 'Legend Title'}, description: {'ar': 'أعلى لقب في اللعبة', 'en': 'Highest title in the game'}, category: ShopItemCategory.titles, priceCoins: 5000, priceGems: 1000),
      ShopItemModel(id: 'frame_gold', name: {'ar': 'إطار ذهبي', 'en': 'Gold Frame'}, description: {'ar': 'إطار ذهبي للصورة الشخصية', 'en': 'Golden frame for profile picture'}, category: ShopItemCategory.frames, priceCoins: 250, discountPercent: 10),
      ShopItemModel(id: 'bp_premium', name: {'ar': 'بطاقة المعركة', 'en': 'Battle Pass'}, description: {'ar': 'بطاقة المعركة للموسم الحالي', 'en': 'Current season battle pass'}, category: ShopItemCategory.bundles, priceCoins: 2000, isFeatured: true),
      ShopItemModel(id: 'coins_pack', name: {'ar': 'حزمة عملات', 'en': 'Coin Pack'}, description: {'ar': '5000 عملة ذهبية', 'en': '5000 gold coins'}, category: ShopItemCategory.bundles, priceCoins: 4500, priceGems: 500, discountPercent: 10),
    ];
  }
}