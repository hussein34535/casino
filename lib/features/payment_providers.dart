class PaymentProviderService {
  static const Map<String, Map<String, dynamic>> providers = {
    'apple_pay': {
      'name': 'Apple Pay',
      'regions': ['US', 'UK', 'CA', 'AU', 'AE', 'SA'],
      'fee': 0.30,
      'enabled': true,
    },
    'google_pay': {
      'name': 'Google Pay',
      'regions': ['US', 'UK', 'DE', 'FR', 'AE', 'SA', 'EG'],
      'fee': 0.30,
      'enabled': true,
    },
    'stripe': {
      'name': 'Stripe',
      'regions': ['GLOBAL'],
      'fee': 0.29,
      'enabled': true,
    },
    'paypal': {
      'name': 'PayPal',
      'regions': ['US', 'UK', 'DE', 'FR', 'IT', 'ES'],
      'fee': 0.35,
      'enabled': true,
    },
    'vodafone_cash': {
      'name': 'فودافون كاش',
      'regions': ['EG'],
      'fee': 0.15,
      'enabled': true,
    },
    'orange_money': {
      'name': 'أورانج موني',
      'regions': ['EG', 'TN', 'CI', 'SN'],
      'fee': 0.15,
      'enabled': true,
    },
    'mada': {
      'name': 'مدى',
      'regions': ['SA'],
      'fee': 0.10,
      'enabled': true,
    },
    'stc_pay': {
      'name': 'STC Pay',
      'regions': ['SA'],
      'fee': 0.12,
      'enabled': true,
    },
    'we_chat_pay': {
      'name': 'WeChat Pay',
      'regions': ['CN'],
      'fee': 0.20,
      'enabled': true,
    },
    'alipay': {
      'name': 'Alipay',
      'regions': ['CN'],
      'fee': 0.20,
      'enabled': true,
    },
    'easypaisa': {
      'name': 'Easypaisa',
      'regions': ['PK'],
      'fee': 0.10,
      'enabled': true,
    },
    'bkash': {
      'name': 'bKash',
      'regions': ['BD'],
      'fee': 0.10,
      'enabled': true,
    },
    'mpesa': {
      'name': 'M-Pesa',
      'regions': ['KE', 'TZ', 'UG', 'ET'],
      'fee': 0.08,
      'enabled': true,
    },
    'pix': {
      'name': 'Pix',
      'regions': ['BR'],
      'fee': 0.05,
      'enabled': true,
    },
    'upi': {
      'name': 'UPI',
      'regions': ['IN'],
      'fee': 0.05,
      'enabled': true,
    },
  };

  static List<Map<String, dynamic>> getAvailableProviders(String region) {
    return providers.entries
        .where((e) => e.value['regions'].contains(region) || e.value['regions'].contains('GLOBAL'))
        .where((e) => e.value['enabled'] == true)
        .map((e) => {'id': e.key, ...e.value})
        .toList();
  }

  static double calculateFee(String providerId, double amount) {
    final provider = providers[providerId];
    if (provider == null) return 0;
    final fee = provider['fee'] as double;
    return amount * fee;
  }
}

class RegionalPricing {
  static const Map<String, Map<String, double>> prices = {
    'premium_monthly': {
      'US': 4.99, 'UK': 3.99, 'EU': 4.49, 'SA': 14.99,
      'AE': 14.99, 'EG': 49.00, 'IN': 199.00, 'CN': 19.00,
      'BR': 14.99, 'PK': 299.00, 'BD': 299.00, 'NG': 1500.00,
    },
    'coins_100': {
      'US': 0.99, 'SA': 3.99, 'AE': 3.99, 'EG': 9.99,
      'IN': 49.00, 'CN': 6.00,
    },
  };

  static double getLocalPrice(String productId, String region) {
    return prices[productId]?[region] ?? prices[productId]?['US'] ?? 4.99;
  }
}
