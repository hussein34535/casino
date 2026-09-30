import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User operations
  Future<void> setUser({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    await _db.collection('users').doc(id).set({
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'xp': 0,
      'level': 1,
      'gamesPlayed': 0,
      'gamesWon': 0,
      'totalScore': 0,
      'streak': 0,
      'coins': 0,
      'isPremium': false,
      'isAdmin': false,
      'isBanned': false,
      'emailVerified': false,
      'language': 'ar',
      'lastActiveAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'friends': [],
      'blockedUsers': [],
      'settings': {
        'notifications': true,
        'soundFx': true,
        'theme': 'dark',
      },
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // Questions operations
  Future<List<QueryDocumentSnapshot>> getQuestions({
    required String type,
    int limit = 50,
    String? difficulty,
  }) async {
    var query = _db.collection('questions')
        .where('type', isEqualTo: type)
        .where('isActive', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .limit(limit);

    if (difficulty != null) {
      query = query.where('difficulty', isEqualTo: difficulty);
    }

    final snapshot = await query.get();
    return snapshot.docs;
  }

  Future<void> addQuestion(Map<String, dynamic> question) async {
    await _db.collection('questions').add(question);
  }

  Future<void> updateQuestion(String id, Map<String, dynamic> data) async {
    await _db.collection('questions').doc(id).update(data);
  }

  // Game sessions
  Future<DocumentSnapshot> getGameSession(String id) async {
    return await _db.collection('games').doc(id).get();
  }

  Future<String> createGameSession(Map<String, dynamic> session) async {
    final doc = await _db.collection('games').add(session);
    return doc.id;
  }

  Future<void> updateGameSession(String id, Map<String, dynamic> data) async {
    await _db.collection('games').doc(id).update(data);
  }

  Stream<DocumentSnapshot> gameSessionStream(String id) {
    return _db.collection('games').doc(id).snapshots();
  }

  /// Live list of rooms waiting for players.
  /// Single-field query (no composite index needed); callers filter
  /// public rooms, search text and sort client-side.
  Stream<QuerySnapshot> openRoomsStream({int limit = 20}) {
    return _db
        .collection('games')
        .where('status', isEqualTo: 'waiting')
        .limit(limit)
        .snapshots();
  }

  Future<QuerySnapshot> getGameSessionByCode(String code) async {
    return await _db.collection('games')
        .where('roomCode', isEqualTo: code)
        .where('status', isEqualTo: 'waiting')
        .limit(1)
        .get();
  }

  // Leaderboard
  Stream<QuerySnapshot> getLeaderboard({String period = 'weekly', int limit = 100}) {
    return _db.collection('leaderboard')
        .where('period', isEqualTo: period)
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots();
  }

  // Achievements
  Future<List<QueryDocumentSnapshot>> getAchievements() async {
    final snapshot = await _db.collection('achievements').get();
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getUserAchievements(String userId) async {
    final snapshot = await _db.collection('userAchievements')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs;
  }

  Future<void> updateUserAchievement(String id, Map<String, dynamic> data) async {
    await _db.collection('userAchievements').doc(id).update(data);
  }

  // Search
  Future<QuerySnapshot> searchUsers(String query) async {
    final q = query.toLowerCase();
    return await _db.collection('users')
        .where('displayName_lower', isGreaterThanOrEqualTo: q)
        .where('displayName_lower', isLessThanOrEqualTo: '$q\uf8ff')
        .limit(20)
        .get();
  }

  // Friends
  Stream<QuerySnapshot> getFriends(String userId) {
    return _db.collection('friends')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots();
  }

  Future<void> sendFriendRequest(String fromId, String toId) async {
    await _db.collection('friends').add({
      'userId': fromId,
      'friendId': toId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('friends').add({
      'userId': toId,
      'friendId': fromId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getFriendRequest(String docId) async {
    return await _db.collection('friends').doc(docId).get();
  }

  Future<void> acceptFriendRequest(String docId) async {
    final doc = await _db.collection('friends').doc(docId).get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>;
    await _db.collection('friends').doc(docId).update({'status': 'accepted'});
    final snapshot = await _db.collection('friends')
        .where('userId', isEqualTo: data['friendId'])
        .where('friendId', isEqualTo: data['userId'])
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    for (final d in snapshot.docs) {
      await d.reference.update({'status': 'accepted'});
    }
  }

  Future<void> deleteFriendRequest(String fromId, String toId) async {
    final snapshot = await _db.collection('friends')
        .where('userId', isEqualTo: fromId)
        .where('friendId', isEqualTo: toId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    for (final d in snapshot.docs) {
      await d.reference.delete();
    }
    final snapshot2 = await _db.collection('friends')
        .where('userId', isEqualTo: toId)
        .where('friendId', isEqualTo: fromId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    for (final d in snapshot2.docs) {
      await d.reference.delete();
    }
  }
}
