import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminFeedbackScreen extends ConsumerWidget {
  const AdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملاحظات المستخدمين'),
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
                  _filterChip('إيجابي', 'positive'),
                  _filterChip('سلبي', 'negative'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _feedbacks.length,
              itemBuilder: (context, index) {
                final fb = _feedbacks[index];
                final rating = fb['rating'] as int;
                final isPositive = rating >= 4;

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
                              backgroundColor: isPositive
                                  ? AppColors.green.withValues(alpha: 0.3)
                                  : AppColors.red.withValues(alpha: 0.3),
                              child: Text(
                                (fb['user'] as String)[0],
                                style: TextStyle(
                                  color: isPositive ? AppColors.green : AppColors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fb['user'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      ...List.generate(5, (i) => Icon(
                                        i < rating ? Icons.star : Icons.star_border,
                                        size: 16,
                                        color: i < rating ? AppColors.yellow : AppColors.grey,
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(fb['date'] as String,
                                style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(fb['comment'] as String,
                              style: const TextStyle(color: AppColors.outline)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.reply, size: 18),
                              label: const Text('رد'),
                              style: TextButton.styleFrom(foregroundColor: AppColors.purple),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text('تجاهل'),
                              style: TextButton.styleFrom(foregroundColor: AppColors.grey),
                              onPressed: () {},
                            ),
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

const List<Map<String, dynamic>> _feedbacks = [
  {
    'user': 'أحمد محمد',
    'rating': 5,
    'comment': 'تطبيق رائع! أستمتع باللعب كل يوم مع أصدقائي. الأسئلة متنوعة وممتعة.',
    'date': '2025-01-15',
  },
  {
    'user': 'سارة علي',
    'rating': 4,
    'comment': 'لعبة جميلة ولكن أتمنى إضافة المزيد من الفئات. التصميم رائع.',
    'date': '2025-01-14',
  },
  {
    'user': 'خالد عمر',
    'rating': 2,
    'comment': 'هناك بعض المشاكل في الاتصال أحياناً. لو سمحتم حلوا مشكلة التأخير.',
    'date': '2025-01-13',
  },
  {
    'user': 'نورة حسن',
    'rating': 5,
    'comment': 'أفضل لعبة مسابقات على الإطلاق! شكراً للفريق الرائع.',
    'date': '2025-01-12',
  },
  {
    'user': 'محمد سعيد',
    'rating': 3,
    'comment': 'جيد ولكن المحتوى محدود. أتمنى إضافة المزيد من الأسئلة العربية.',
    'date': '2025-01-11',
  },
  {
    'user': 'فاطمة الزهراء',
    'rating': 5,
    'comment': 'تطبيق ممتاز! ابني يحب اللعب به ويتعلم الكثير من المعلومات الجديدة.',
    'date': '2025-01-10',
  },
];
