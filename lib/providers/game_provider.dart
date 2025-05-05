import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'
    show rootBundle; // Import for asset loading
import 'dart:convert'; // Import for jsonDecode
import 'dart:math';

import 'package:game_show_app/models/player.dart';
import 'package:game_show_app/models/question.dart';
import 'package:game_show_app/models/game_type.dart';

class GameProvider with ChangeNotifier {
  List<Player> _players = [];
  List<Question> _questions = [];
  GameType? _selectedGameType;
  int _currentPlayerIndex = 0; // لتحديد دور اللاعب (قد لا نحتاجه في هذه النسخة)
  int _currentQuestionIndex = 0;

  bool _isLoadingQuestions = false;
  bool get isLoadingQuestions => _isLoadingQuestions;

  List<Player> get players => _players;
  List<Question> get questions => _questions; // الأسئلة للنوع المختار
  GameType? get selectedGameType => _selectedGameType;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;
  int get currentQuestionIndex => _currentQuestionIndex;

  // --- إعداد اللعبة ---
  void setPlayers(List<String> playerNames) {
    _players = playerNames.map((name) => Player(name: name)).toList();
    _currentQuestionIndex = 0; // إعادة تعيين السؤال عند بدء لعبة جديدة
    _questions = []; // تفريغ الأسئلة السابقة
    _selectedGameType = null; // إعادة تعيين نوع اللعبة
    notifyListeners();
  }

  Future<void> selectGameType(GameType type) async {
    _selectedGameType = type;
    _isLoadingQuestions = true;
    _questions = []; // Clear previous questions immediately
    _currentQuestionIndex = 0;
    notifyListeners(); // Notify UI that loading has started

    try {
      _questions =
          await _loadQuestionsForType(type); // Load questions for the type
      _questions.shuffle(); // Shuffle after loading
    } catch (e) {
      print("Error loading questions for type $type: $e");
      _questions = []; // Ensure questions list is empty on error
      // Optionally, set an error state to show in the UI
    }

    _isLoadingQuestions = false;
    _currentQuestionIndex = 0; // Reset index after loading/shuffling
    notifyListeners(); // Notify UI that loading is complete (with questions or error)
  }

  // --- أثناء اللعب ---
  void updateScore(int playerIndex, int amount) {
    if (playerIndex >= 0 && playerIndex < _players.length) {
      _players[playerIndex].score += amount;
      // التأكد أن النقاط لا تقل عن صفر (اختياري)
      // if (_players[playerIndex].score < 0) {
      //   _players[playerIndex].score = 0;
      // }
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_questions.isEmpty) return; // لا تفعل شيئًا إذا لم تكن هناك أسئلة

    // Only increment if there are more questions available in the shuffled list
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners(); // Notify listeners only if the index actually changed
    }
  }

  void resetGame() {
    _players = [];
    _questions = [];
    _selectedGameType = null;
    _currentPlayerIndex = 0;
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // --- بيانات مؤقتة (Dummy Data) ---
  Future<List<Question>> _loadQuestionsForType(GameType type) async {
    switch (type) {
      case GameType.trivia:
        // Load trivia questions from the JSON asset
        try {
          final String jsonString =
              await rootBundle.loadString('assets/questions_general.json');
          final List<dynamic> jsonList = jsonDecode(jsonString);

          // Convert list of JSON objects to Questions
          return jsonList.map<Question>((json) {
            // Generate a simple unique ID using question text hashcode
            // Ideally, your JSON should contain unique IDs
            String questionId =
                'gen_${json['question']?.hashCode ?? Random().nextInt(999999)}';
            return Question(
              id: questionId,
              type: type,
              text: json['question'] as String? ??
                  'نص سؤال غير متوفر', // Handle potential null
              answer: json['answer'] as String? ?? '', // Handle potential null
            );
          }).toList();
        } catch (e) {
          print("Error loading or parsing questions_general.json: $e");
          return []; // Return empty list on error
        }
      case GameType.movies:
        // Load movie questions from the JSON asset
        try {
          final String jsonString =
              await rootBundle.loadString('assets/movies_series.json');
          final List<dynamic> jsonList = jsonDecode(jsonString);

          // Convert list of JSON objects to Questions
          return jsonList.map<Question>((json) {
            String questionId =
                'mov_${json['question']?.hashCode ?? Random().nextInt(999999)}';
            return Question(
              id: questionId,
              type: type,
              text: json['question'] as String? ?? 'نص سؤال غير متوفر',
              answer: json['answer'] as String? ?? '',
            );
          }).toList();
        } catch (e) {
          print("Error loading or parsing movies_series.json: $e");
          return []; // Return empty list on error
        }
      case GameType.music:
        return [
          Question(
              id: 'mu1',
              type: type,
              text: 'من هو المغني وما اسم هذه الأغنية؟',
              audioUrl: null,
              singerName: 'كاظم الساهر',
              songName: 'المحكمة',
              answer: 'كاظم الساهر - المحكمة'),
          Question(
              id: 'mu2',
              type: type,
              text: 'من هو المغني وما اسم هذه الأغنية؟',
              audioUrl: null,
              singerName: 'فيروز',
              songName: 'سألوني الناس',
              answer: 'فيروز - سألوني الناس'),
        ];
      case GameType.puzzles:
        // Load puzzles from the JSON asset
        try {
          final String jsonString =
              await rootBundle.loadString('assets/puzzle.json');
          final List<dynamic> jsonList = jsonDecode(jsonString);

          // Convert list of JSON objects to Questions
          return jsonList.map<Question>((json) {
            // Generate a simple unique ID using question text hashcode
            String questionId =
                'puz_${json['question']?.hashCode ?? Random().nextInt(999999)}';
            return Question(
              id: questionId,
              type: type,
              text: json['question'] as String? ?? 'نص لغز غير متوفر',
              answer: json['answer'] as String? ?? '',
            );
          }).toList();
        } catch (e) {
          print("Error loading or parsing puzzle.json: $e");
          return []; // Return empty list on error
        }
      case GameType.words:
        // Load words from the simpler JSON array asset
        try {
          // Update file path
          final String jsonString =
              await rootBundle.loadString('assets/words_list.json');
          // Decode directly into a List<dynamic>
          final List<dynamic> wordsList = jsonDecode(jsonString);

          // Convert list of dynamic (likely strings) to Questions
          return wordsList.map<Question>((word) {
            // Generate a simple unique ID for each word question
            // Using hashCode for simplicity, though not guaranteed unique for very large lists
            String wordId = 'w_${word.hashCode}';
            return Question(
              id: wordId,
              type: type,
              text: word.toString(), // Ensure it's a string
              answer: word.toString(), // Answer is the same word
            );
          }).toList();
        } catch (e) {
          print("Error loading or parsing words_list.json: $e");
          return []; // Return empty list on error
        }
      default:
        return [];
    }
  }

  // --- النتائج ---
  List<Player> getRankedPlayers() {
    List<Player> sortedPlayers = List.from(_players);
    sortedPlayers.sort((a, b) => b.score.compareTo(a.score)); // ترتيب تنازلي
    return sortedPlayers;
  }

  // --- Card System ---
  void giveYellowCard(int playerIndex) {
    if (playerIndex >= 0 && playerIndex < _players.length) {
      _players[playerIndex].yellowCards++;
      updateScore(playerIndex, -1); // Deduct 1 point for yellow card
      // No need for notifyListeners() here as updateScore already calls it
    }
  }

  void giveRedCard(int playerIndex) {
    if (playerIndex >= 0 && playerIndex < _players.length) {
      _players[playerIndex].redCards++;
      updateScore(playerIndex, -3); // Deduct 3 points for red card
      // No need for notifyListeners() here as updateScore already calls it
    }
  }
  // --- End Card System ---
}
