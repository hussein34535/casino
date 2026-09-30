import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:game_show_app/core/utils/app_logger.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';
import 'package:game_show_app/services/firebase/auth_service.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepositoryImpl(this._authService, this._firestoreService);

  @override
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((fbUser) async {
      if (fbUser == null) return null;
      return await _loadFullUser(fbUser);
    });
  }

  @override
  Future<UserModel?> get currentUser async {
    final user = _authService.currentUser;
    if (user == null) return null;
    return await _loadFullUser(user);
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final result = await _authService.signInWithEmail(email, password);
    return _mapFirebaseUser(result.user!);
  }

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String displayName) async {
    final result =
        await _authService.signUpWithEmail(email, password, displayName);
    await _firestoreService.setUser(
      id: result.user!.uid,
      email: email,
      displayName: displayName,
    );
    return _mapFirebaseUser(result.user!);
  }

  @override
  Future<UserModel> signInWithApple() async {
    final result = await _authService.signInWithApple();
    final user = result.user!;
    try {
      await user.getIdToken(true);
      final doc = await _firestoreService.getUser(user.uid);
      if (!doc.exists) {
        await _firestoreService.setUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'User',
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      AppLogger.error('Apple sign-in profile sync failed (non-fatal)', e);
    }
    return _mapFirebaseUser(user);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    final user = result.user!;
    // Ensure the auth token has propagated before touching Firestore,
    // and never let a profile-sync failure fail the sign-in itself.
    try {
      await user.getIdToken(true);
      final doc = await _firestoreService.getUser(user.uid);
      if (!doc.exists) {
        await _firestoreService.setUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'User',
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      AppLogger.error('Google sign-in profile sync failed (non-fatal)', e);
    }
    return _mapFirebaseUser(user);
  }

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _authService.sendPasswordResetEmail(email);

  @override
  Future<void> deleteAccount() => _authService.deleteAccount();

  UserModel _mapFirebaseUser(fb.User user) {
    String displayName = user.displayName ?? '';
    if (displayName.trim().isEmpty) {
      displayName = user.email?.split('@').first ?? 'لاعب مجهول';
    }
    return UserModel(
      id: user.uid, 
      email: user.email ?? '', 
      displayName: displayName, 
      photoUrl: user.photoURL, 
      emailVerified: user.emailVerified
    );
  }

  Future<UserModel> _loadFullUser(fb.User user) async {
    try {
      final doc = await _firestoreService.getUser(user.uid);
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      AppLogger.error('Failed to load full user from Firestore', e);
    }
    return _mapFirebaseUser(user);
  }
}
