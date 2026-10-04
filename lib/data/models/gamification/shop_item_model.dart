import 'package:cloud_firestore/cloud_firestore.dart';

enum ShopItemCategory { avatars, themes, powerUps, boosters, titles, frames, bundles }

class ShopItemModel {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final ShopItemCategory category;
  final int price;
  final String currency;
  final int? discountedPrice;
  final int levelRequirement;
  final int priceCoins;
  final int priceGems;
  final int discountPercent;
  final String? itemType;
  final String? itemId;
  final String? imageUrl;
  final bool isFeatured;
  final bool isLimited;
  final DateTime? availableUntil;

  ShopItemModel({
    required this.id,
    Map<String, String>? name,
    Map<String, String>? description,
    required this.category,
    this.price = 0,
    this.currency = 'coins',
    this.discountedPrice,
    this.levelRequirement = 0,
    this.priceCoins = 0,
    this.priceGems = 0,
    this.discountPercent = 0,
    this.itemType,
    this.itemId,
    this.imageUrl,
    this.isFeatured = false,
    this.isLimited = false,
    this.availableUntil,
  })  : name = name ?? {'ar': 'منتج', 'en': 'Item'},
        description = description ??
            {'ar': 'منتج في المتجر', 'en': 'Shop item'};

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  int get discountedCoins {
    if (discountPercent <= 0) return priceCoins;
    return priceCoins - (priceCoins * discountPercent ~/ 100);
  }

  int get discountedGems {
    if (discountPercent <= 0) return priceGems;
    return priceGems - (priceGems * discountPercent ~/ 100);
  }

  factory ShopItemModel.fromJson(Map<String, dynamic> json) => ShopItemModel(
        id: json['id'] as String? ?? '',
        name: (json['name'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        description: (json['description'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {'ar': '', 'en': ''},
        category: ShopItemCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => ShopItemCategory.avatars,
        ),
        price: json['price'] as int? ?? 0,
        currency: json['currency'] as String? ?? 'coins',
        discountedPrice: json['discountedPrice'] as int?,
        levelRequirement: json['levelRequirement'] as int? ?? 0,
        priceCoins: json['priceCoins'] as int? ?? 0,
        priceGems: json['priceGems'] as int? ?? 0,
        discountPercent: json['discountPercent'] as int? ?? 0,
        itemType: json['itemType'] as String?,
        itemId: json['itemId'] as String?,
        imageUrl: json['imageUrl'] as String?,
        isFeatured: json['isFeatured'] as bool? ?? false,
        isLimited: json['isLimited'] as bool? ?? false,
        availableUntil: _parseDate(json['availableUntil']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category.name,
        'price': price,
        'currency': currency,
        'discountedPrice': discountedPrice,
        'levelRequirement': levelRequirement,
        'priceCoins': priceCoins,
        'priceGems': priceGems,
        'discountPercent': discountPercent,
        'itemType': itemType,
        'itemId': itemId,
        'imageUrl': imageUrl,
        'isFeatured': isFeatured,
        'isLimited': isLimited,
        'availableUntil': availableUntil,
      };
}
