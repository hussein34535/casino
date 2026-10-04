import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_show_app/services/firebase/seed_service.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(ref.read(firestoreProvider));
});

final seedQuestionsProvider = FutureProvider.autoDispose<SeedResult>((ref) async {
  final service = ref.read(seedServiceProvider);
  return service.seedAllQuestions();
});
