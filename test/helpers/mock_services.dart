import 'dart:async';

class MockFirestoreService {
  final Map<String, Map<String, dynamic>> _collections = {};
  bool shouldThrow = false;

  Future<void> setUser({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    if (shouldThrow) throw Exception('Mock error');
    _collections['users_$id'] = {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    if (shouldThrow) throw Exception('Mock error');
    return _collections['users_$uid'];
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    if (shouldThrow) throw Exception('Mock error');
    _collections['users_$uid']?.addAll(data);
  }

  Future<List<Map<String, dynamic>>> getQuestions({
    required String type,
    int limit = 50,
    String? difficulty,
  }) async {
    if (shouldThrow) throw Exception('Mock error');
    return [];
  }

  Future<String> createGameSession(Map<String, dynamic> session) async {
    if (shouldThrow) throw Exception('Mock error');
    final id = 'session_${DateTime.now().millisecondsSinceEpoch}';
    _collections['game_$id'] = session;
    return id;
  }

  Future<void> updateGameSession(String id, Map<String, dynamic> data) async {
    if (shouldThrow) throw Exception('Mock error');
  }

  Stream<Map<String, dynamic>?> gameSessionStream(String id) {
    return Stream.value(_collections['game_$id']);
  }
}

class MockAuthService {
  bool shouldThrow = false;
  bool isSignedIn = false;

  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    if (shouldThrow) throw Exception('Mock error');
    isSignedIn = true;
    return {'uid': 'mock_uid', 'email': email};
  }

  Future<Map<String, dynamic>> signUpWithEmail(String email, String password, String displayName) async {
    if (shouldThrow) throw Exception('Mock error');
    isSignedIn = true;
    return {'uid': 'new_uid', 'email': email, 'displayName': displayName};
  }

  Future<void> signOut() async {
    if (shouldThrow) throw Exception('Mock error');
    isSignedIn = false;
  }

  Stream<bool> get authStateChanges => Stream.value(isSignedIn);

  Map<String, dynamic>? get currentUser => isSignedIn ? {'uid': 'mock_uid'} : null;
}

class MockStorageService {
  bool shouldThrow = false;

  Future<String> uploadAvatar(String userId, String filePath) async {
    if (shouldThrow) throw Exception('Mock error');
    return 'https://storage.example.com/avatars/$userId.jpg';
  }

  Future<String> uploadQuestionAudio(String questionId, String filePath) async {
    if (shouldThrow) throw Exception('Mock error');
    return 'https://storage.example.com/audio/$questionId.mp3';
  }

  Future<String> uploadQuestionImage(String questionId, String filePath) async {
    if (shouldThrow) throw Exception('Mock error');
    return 'https://storage.example.com/images/$questionId.jpg';
  }

  Future<void> deleteFile(String url) async {
    if (shouldThrow) throw Exception('Mock error');
  }
}
