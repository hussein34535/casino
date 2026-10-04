import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/domain/repositories/auth_repository.dart';
import 'package:game_show_app/data/repositories/auth_repository_impl.dart';
import 'package:game_show_app/services/firebase/auth_service.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authServiceProvider),
    ref.read(firestoreServiceProvider),
  );
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges;
});

final authLoadingProvider = StateProvider<bool>((ref) => false);
final authErrorProvider = StateProvider<String?>((ref) => null);
