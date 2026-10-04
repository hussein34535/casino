import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/data/repositories/social_repository_impl.dart';
import 'package:game_show_app/domain/repositories/social_repository.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepositoryImpl(ref.read(firestoreServiceProvider));
});

final friendsProvider = StreamProvider<List<UserModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return ref.read(socialRepositoryProvider).getFriends(user.id);
});
