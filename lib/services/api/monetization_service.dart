import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_functions/cloud_functions.dart';

enum PurchaseState { idle, loading, purchased, error, restored }

class MonetizationNotifier extends ValueNotifier<PurchaseState> {
  MonetizationNotifier() : super(PurchaseState.idle);

  void loading() => value = PurchaseState.loading;
  void purchased() => value = PurchaseState.purchased;
  void restored() => value = PurchaseState.restored;
  void error() => value = PurchaseState.error;
  void reset() => value = PurchaseState.idle;
}

class MonetizationService {
  static const String premiumMonthlyId = 'xo_premium_monthly';
  static const String premiumYearlyId = 'xo_premium_yearly';
  static const String battlePassId = 'xo_battle_pass';
  static const String coins100Id = 'xo_coins_100';
  static const String coins500Id = 'xo_coins_500';
  static const String coins1000Id = 'xo_coins_1000';

  static const List<String> consumables = [coins100Id, coins500Id, coins1000Id];
  static const List<String> nonConsumables = [premiumMonthlyId, premiumYearlyId, battlePassId];
  static const List<String> allProducts = [...consumables, ...nonConsumables];

  final InAppPurchase _inAppPurchase;
  final MonetizationNotifier stateNotifier;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _disposed = false;

  MonetizationService({
    InAppPurchase? inAppPurchase,
    MonetizationNotifier? notifier,
  })  : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance,
        stateNotifier = notifier ?? MonetizationNotifier();

  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => List.unmodifiable(_products);

  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) return;

    _subscription = _inAppPurchase.purchaseStream.listen(_handlePurchaseUpdates);

    final details = await _inAppPurchase.queryProductDetails(allProducts.toSet());
    if (details.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found in store: ${details.notFoundIDs}');
    }
    _products = details.productDetails;
  }

  Future<bool> buyProduct(String productId) async {
    if (!_isAvailable) {
      stateNotifier.error();
      throw PlatformException(
        code: 'STORE_UNAVAILABLE',
        message: 'In-app purchases are not available on this device',
      );
    }

    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw PlatformException(
        code: 'PRODUCT_NOT_FOUND',
        message: 'Product $productId not found',
      ),
    );

    stateNotifier.loading();

    final purchaseParam = PurchaseParam(productDetails: product);
    final result = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    if (!result) {
      stateNotifier.reset();
    }
    return result;
  }

  Future<bool> buyConsumable(String productId, {String? userId}) async {
    if (!_isAvailable) {
      stateNotifier.error();
      throw PlatformException(
        code: 'STORE_UNAVAILABLE',
        message: 'In-app purchases are not available on this device',
      );
    }

    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw PlatformException(
        code: 'PRODUCT_NOT_FOUND',
        message: 'Product $productId not found',
      ),
    );

    stateNotifier.loading();

    final purchaseParam = PurchaseParam(productDetails: product);
    final result = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

    if (!result) {
      stateNotifier.reset();
    }
    return result;
  }

  Future<bool> restorePurchases() async {
    if (!_isAvailable) {
      stateNotifier.error();
      throw PlatformException(
        code: 'STORE_UNAVAILABLE',
        message: 'In-app purchases are not available on this device',
      );
    }

    stateNotifier.loading();
    await _inAppPurchase.restorePurchases();
    return true;
  }

  Future<bool> _verifyOnServer(PurchaseDetails purchase) async {
    try {
      final functions = FirebaseFunctions.instance;
      final result = await functions.httpsCallable('verifyPurchase').call({
        'productId': purchase.productID,
        'purchaseToken': purchase.verificationData.serverVerificationData,
        'source': purchase.verificationData.source,
      });
      return result.data['verified'] == true;
    } catch (e) {
      debugPrint('Server verification failed: $e');
      return false;
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    if (_disposed) return;

    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          _verifyOnServer(purchase).then((verified) {
            if (verified) {
              if (purchase.pendingCompletePurchase) {
                _inAppPurchase.completePurchase(purchase);
              }
              stateNotifier.purchased();
            } else {
              stateNotifier.error();
            }
          });
          break;
        case PurchaseStatus.error:
          stateNotifier.error();
          break;
        case PurchaseStatus.restored:
          stateNotifier.restored();
          break;
        case PurchaseStatus.canceled:
          stateNotifier.reset();
          break;
      }
    }
  }

  String getLocalizedPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return product.price;
    } catch (_) {
      final prices = {
        premiumMonthlyId: '\$4.99',
        premiumYearlyId: '\$29.99',
        battlePassId: '\$9.99',
        coins100Id: '\$0.99',
        coins500Id: '\$3.99',
        coins1000Id: '\$6.99',
      };
      return prices[productId] ?? '\$0.00';
    }
  }

  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    stateNotifier.dispose();
  }
}
