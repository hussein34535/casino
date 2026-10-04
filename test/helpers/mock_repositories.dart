import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/data/models/game/player_model.dart';
import 'package:game_show_app/data/models/question/question_model.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/models/leaderboard/leaderboard_model.dart';
import 'package:game_show_app/data/models/achievement/achievement_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';
import 'package:game_show_app/domain/repositories/game_repository.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  bool shouldThrow = false;
  Exception? errorToThrow;

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);

  @override
  Future<UserModel?> get currentUser async => _currentUser;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    return _currentUser ?? UserModel(id: 'mock', email: email, displayName: 'Mock User');
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String displayName) async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    return UserModel(id: 'new_user', email: email, displayName: displayName);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    return _currentUser ?? UserModel(id: 'google', email: 'google@user.com', displayName: 'Google User');
  }

  @override
  Future<UserModel> signInWithApple() async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    return _currentUser ?? UserModel(id: 'apple', email: 'apple@user.com', displayName: 'Apple User');
  }

  @override
  Future<void> signOut() async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
  }

  @override
  Future<void> deleteAccount() async {
    if (shouldThrow) throw errorToThrow ?? Exception('Mock error');
    _currentUser = null;
  }
}

class MockGameRepository implements GameRepository {
  List<QuestionModel> questions = [];
  Map<String, GameSessionModel> sessions = {};
  bool shouldThrow = false;

  @override
  Future<List<QuestionModel>> getQuestions(String type, {String? difficulty, int limit = 10}) async {
    if (shouldThrow) throw Exception('Mock error');
    var result = questions.where((q) => q.type == type);
    if (difficulty != null) {
      result = result.where((q) => q.difficulty == difficulty);
    }
    return result.take(limit).toList();
  }

  @override
  Future<String> createSession(GameSessionModel session) async {
    if (shouldThrow) throw Exception('Mock error');
    sessions[session.id] = session;
    return session.id;
  }

  @override
  Future<void> updateSession(String id, Map<String, dynamic> data) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Stream<GameSessionModel?> sessionStream(String id) {
    return Stream.value(sessions[id]);
  }

  @override
  Future<void> submitAnswer(String sessionId, String playerId, String questionId, String answer) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<List<PlayerModel>> getSessionPlayers(String sessionId) async {
    if (shouldThrow) throw Exception('Mock error');
    return sessions[sessionId]?.players ?? [];
  }
}

class MockUserRepository implements UserRepository {
  UserModel? user;
  List<LeaderboardEntry> leaderboard = [];
  List<AchievementModel> achievements = [];
  List<UserAchievement> userAchievements = [];
  bool shouldThrow = false;

  @override
  Future<UserModel> getUserProfile(String uid) async {
    if (shouldThrow) throw Exception('Mock error');
    if (user == null) throw Exception('User not found');
    return user!;
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<void> uploadAvatar(String uid, String filePath) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({String period = 'weekly'}) async {
    if (shouldThrow) throw Exception('Mock error');
    return leaderboard;
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    if (shouldThrow) throw Exception('Mock error');
    return achievements;
  }

  @override
  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    if (shouldThrow) throw Exception('Mock error');
    return userAchievements;
  }

  @override
  Future<void> addXp(String uid, int amount) async {
    if (shouldThrow) throw Exception('Mock error');
    user?.xp = (user?.xp ?? 0) + amount;
  }

  @override
  Future<void> addCoins(String uid, int amount) async {
    if (shouldThrow) throw Exception('Mock error');
    user?.coins = (user?.coins ?? 0) + amount;
  }

  @override
  Future<void> addItemToInventory(String userId, String itemId) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<List<String>> getInventory(String userId) async {
    if (shouldThrow) throw Exception('Mock error');
    return [];
  }

  @override
  Future<bool> equipItem(String userId, String itemId) async {
    if (shouldThrow) throw Exception('Mock error');
    return true;
  }
}

class MockSocialRepository implements SocialRepository {
  List<UserModel> friends = [];
  bool shouldThrow = false;

  @override
  Stream<List<UserModel>> getFriends(String userId) {
    return Stream.value(friends);
  }

  @override
  Future<void> sendFriendRequest(String fromId, String toId) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<void> acceptFriendRequest(String docId) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<void> rejectFriendRequest(String docId) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<void> blockUser(String userId, String blockedId) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    if (shouldThrow) throw Exception('Mock error');
    return friends.where((f) => f.displayName.contains(query)).toList();
  }
}
