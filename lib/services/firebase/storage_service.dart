import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadAvatar(String userId, File imageFile) async {
    final ref = _storage.ref().child('avatars').child('$userId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String> uploadQuestionAudio(String questionId, File audioFile) async {
    final ref = _storage.ref().child('audio').child('questions').child('$questionId.mp3');
    await ref.putFile(audioFile);
    return await ref.getDownloadURL();
  }

  Future<String> uploadQuestionImage(String questionId, File imageFile) async {
    final ref = _storage.ref().child('images').child('questions').child('$questionId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // ignore
    }
  }
}
