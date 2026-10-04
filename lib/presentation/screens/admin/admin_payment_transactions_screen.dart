import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminPaymentTransactionsScreen extends ConsumerWidget {
  const AdminPaymentTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعاملات المالية'),
        backgroundColor: AppColors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('الكل', 'all'),
                  _filterChip('مكتملة', 'completed'),
                  _filterChip('قيد الانتظار', 'pending'),
                  _filterChip('فاشلة', 'failed'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final t = _transactions[index];
                final statusColor = t['status'] == 'completed'
                    ? AppColors.green
                    : t['status'] == 'pending'
                        ? AppColors.yellow
                        : AppColors.red;
                final statusLabel = t['status'] == 'completed'
                    ? 'مكتملة'
                    : t['status'] == 'pending'
                        ? 'قيد الانتظار'
                        : 'فاشلة';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.purple.withValues(alpha: 0.3),
                              child: Text(
                                (t['user'] as String)[0],
                                style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t['user'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(t['paymentMethod'] as String,
                                      style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            Text(
                              t['amount'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(statusLabel,
                                  style: TextStyle(fontSize: 12, color: statusColor)),
                            ),
                            const Spacer(),
                            Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(t['date'] as String,
                                style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: value == 'all',
        selectedColor: AppColors.purple,
      ),
    );
  }
}

const List<Map<String, dynamic>> _transactions = [
  {
    'user': 'أحمد محمد',
    'amount': '\$50.00',
    'paymentMethod': 'Visa •••• 4242',
    'status': 'completed',
    'date': '2025-01-15',
  },
  {
    'user': 'سارة علي',
    'amount': '\$25.00',
    'paymentMethod': 'PayPal',
    'status': 'pending',
    'date': '2025-01-14',
  },
  {
    'user': 'خالد عمر',
    'amount': '\$100.00',
    'paymentMethod': 'Mastercard •••• 8888',
    'status': 'failed',
    'date': '2025-01-13',
  },
  {
    'user': 'نورة حسن',
    'amount': '\$75.00',
    'paymentMethod': 'Apple Pay',
    'status': 'completed',
    'date': '2025-01-12',
  },
  {
    'user': 'محمد سعيد',
    'amount': '\$30.00',
    'paymentMethod': 'Visa •••• 1234',
    'status': 'completed',
    'date': '2025-01-11',
  },
  {
    'user': 'فاطمة الزهراء',
    'amount': '\$200.00',
    'paymentMethod': 'Bank Transfer',
    'status': 'pending',
    'date': '2025-01-10',
  },
];
