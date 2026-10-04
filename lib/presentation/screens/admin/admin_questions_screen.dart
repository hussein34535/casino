import 'package:flutter/material.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminQuestionsScreen extends StatefulWidget {
  const AdminQuestionsScreen({super.key});

  @override
  State<AdminQuestionsScreen> createState() => _AdminQuestionsScreenState();
}

class _AdminQuestionsScreenState extends State<AdminQuestionsScreen> {
  String _selectedCategory = 'all';
  final List<Map<String, dynamic>> _questions = List.generate(100, (i) => {
    'id': 'q$i',
    'text': 'سؤال اختبار رقم $i ما هي الإجابة الصحيحة لهذا السؤال؟',
    'answer': 'الإجابة رقم $i',
    'category': ['trivia', 'movies', 'music', 'puzzles', 'words'][i % 5],
    'difficulty': ['easy', 'medium', 'hard'][i % 3],
    'isApproved': i % 7 != 0,
    'reports': i % 10 == 0 ? i % 5 : 0,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'all'
        ? _questions
        : _questions.where((q) => q['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('الأسئلة'), backgroundColor: AppColors.purple),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _categoryChip('الكل', 'all'),
                  _categoryChip('معلومات عامة', 'trivia'),
                  _categoryChip('أفلام', 'movies'),
                  _categoryChip('موسيقى', 'music'),
                  _categoryChip('ألغاز', 'puzzles'),
                  _categoryChip('كلمات', 'words'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final q = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: q['isApproved'] ? Colors.green : AppColors.yellow,
                      child: Icon(
                        q['isApproved'] ? Icons.check : Icons.pending,
                        size: 16, color: Colors.black,
                      ),
                    ),
                    title: Text(q['text'], maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Row(
                      children: [
                        _difficultyBadge(q['difficulty']),
                        const SizedBox(width: 8),
                        if (q['reports'] > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(10)),
                            child: Text('${q['reports']} بلاغ', style: const TextStyle(fontSize: 10, color: AppColors.white)),
                          ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الإجابة: ${q['answer']}', style: const TextStyle(color: AppColors.orange)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.check_circle, size: 18),
                                  label: const Text('موافقة'),
                                  onPressed: () => setState(() => q['isApproved'] = true),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text('حذف'),
                                  style: TextButton.styleFrom(foregroundColor: AppColors.red),
                                  onPressed: () => setState(() => _questions.remove(q)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = value),
        selectedColor: AppColors.purple,
      ),
    );
  }

  Widget _difficultyBadge(String difficulty) {
    final colors = {'easy': Colors.green, 'medium': AppColors.yellow, 'hard': AppColors.red};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors[difficulty]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(difficulty, style: TextStyle(fontSize: 10, color: colors[difficulty])),
    );
  }
}
