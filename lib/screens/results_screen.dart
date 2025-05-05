import 'package:flutter/material.dart';
import 'package:game_show_app/providers/game_provider.dart';
import 'package:game_show_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:game_show_app/models/player.dart'; // استيراد Player

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  // --- دالة للتعامل مع زر الرجوع ---
  Future<bool> _onWillPop(BuildContext context) async {
    // إعادة تعيين حالة اللعبة
    Provider.of<GameProvider>(context, listen: false).resetGame();
    // العودة إلى الشاشة الرئيسية وإزالة كل ما فوقها
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
    return false; // منع السلوك الافتراضي
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final rankedPlayers =
        gameProvider.getRankedPlayers(); // الحصول على اللاعبين مرتبين
    final highestScore =
        rankedPlayers.isNotEmpty ? rankedPlayers.first.score : 0;

    // تغليف بـ WillPopScope
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('النتائج النهائية'),
          automaticallyImplyLeading: false, // منع زر الرجوع
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // عنوان مميز للفائز
              if (rankedPlayers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '🏆 الفائز${rankedPlayers.where((p) => p.score == highestScore).length > 1 ? 'ون' : ''}! 🏆',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.amber[700], // لون ذهبي للفوز
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // قائمة اللاعبين المرتبة
              Expanded(
                child: ListView.builder(
                  itemCount: rankedPlayers.length,
                  itemBuilder: (context, index) {
                    final player = rankedPlayers[index];
                    final isWinner = player.score == highestScore &&
                        highestScore >=
                            0; // التحقق من أنه فائز (وليس الكل صفر مثلاً)

                    return Card(
                      elevation: isWinner ? 4.0 : 2.0, // إبراز الفائز
                      color: isWinner
                          ? Colors.teal[50]?.withOpacity(0.1)
                          : null, // تعديل طفيف للون الفائز
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isWinner
                              ? Colors.amber
                              : Theme.of(context)
                                  .colorScheme
                                  .surface, // استخدام لون السطح للخلفية العادية
                          foregroundColor: isWinner
                              ? Colors.black
                              : Colors.white, // لون النص داخل الدائرة
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          player.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                isWinner ? FontWeight.bold : FontWeight.normal,
                            color: isWinner
                                ? Colors.amber[100]
                                : null, // إبراز اسم الفائز بلون مختلف
                          ),
                        ),
                        trailing: Text(
                          '${player.score} نقطة',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // زر العودة للعب مرة أخرى
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('العب مرة أخرى'),
                onPressed: () {
                  // نفس منطق _onWillPop
                  _onWillPop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
