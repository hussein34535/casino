import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/repositories/user_repository_impl.dart';
import 'package:game_show_app/domain/repositories/user_repository.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/infrastructure_provider.dart';
import 'package:game_show_app/services/firebase/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.read(firestoreServiceProvider),
    ref.read(storageServiceProvider),
    ref.read(cacheProvider),
  );
});

final userProfileProvider = FutureProvider.family<UserModel, String>((ref, uid) {
  return ref.read(userRepositoryProvider).getUserProfile(uid);
});

final userLoadingProvider = StateProvider<bool>((ref) => false);
