import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

class SecurityService {
  // Task 311: End-to-end encryption
  // TODO: REPLACE with proper AES encryption using encrypt package
  // This is a placeholder using SHA-256 hashing (not encryption)
  String encryptMessage(String message, String publicKey) {
    final bytes = utf8.encode(message);
    final digest = sha256.convert(bytes);
    return base64Encode(utf8.encode('${digest.toString()}:$message'));
  }

  // TODO: REPLACE with proper AES decryption using encrypt package
  // This is a placeholder that just extracts the original message
  String decryptMessage(String encrypted, String privateKey) {
    final decoded = utf8.decode(base64Decode(encrypted));
    final parts = decoded.split(':');
    return parts.length > 1 ? parts.sublist(1).join(':') : '';
  }

  // Task 316: Anti-cheat - detect screen recording
  Future<bool> isScreenBeingRecorded() async {
    try {
      final result = await MethodChannel('xo/security').invokeMethod<bool>('isRecording');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  // Task 317: VPN detection
  Future<bool> isVpnActive() async {
    try {
      final result = await MethodChannel('xo/security').invokeMethod<bool>('isVpnActive');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  // Task 318: Rate limiting
  final Map<String, List<DateTime>> _requestLog = {};

  bool isRateLimited(String endpoint, {int maxRequests = 60, Duration window = const Duration(minutes: 1)}) {
    final now = DateTime.now();
    _requestLog[endpoint] ??= [];
    _requestLog[endpoint]!.removeWhere((t) => now.difference(t) > window);
    _requestLog[endpoint]!.add(now);
    return _requestLog[endpoint]!.length > maxRequests;
  }

  // Task 325: JWT with rotation
  String generateSessionToken(String userId) {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final payload = base64Url.encode(utf8.encode(jsonEncode({
      'uid': userId,
      'iat': DateTime.now().millisecondsSinceEpoch,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    })));
    final signature = sha256.convert(utf8.encode('$payload:${base64Url.encode(bytes)}')).toString();
    return '$payload.$signature';
  }

  bool validateToken(String token) {
    final parts = token.split('.');
    if (parts.length != 2) return false;
    try {
      final payload = jsonDecode(utf8.decode(base64Url.decode(parts[0]))) as Map<String, dynamic>;
      final exp = payload['exp'] as int;
      return DateTime.now().millisecondsSinceEpoch < exp;
    } catch (_) {
      return false;
    }
  }

  // Task 332: Data anonymization
  Map<String, dynamic> anonymizeData(Map<String, dynamic> data) {
    final anonymized = Map<String, dynamic>.from(data);
    if (anonymized.containsKey('email')) {
      final email = anonymized['email'] as String;
      final parts = email.split('@');
      anonymized['email'] = '${parts[0][0]}***@${parts[1]}';
    }
    if (anonymized.containsKey('displayName')) {
      anonymized['displayName'] = 'User_${data['id'].toString().substring(0, 8)}';
    }
    return anonymized;
  }

  // Task 339: Age verification
  bool verifyAge(DateTime birthDate) {
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    return age >= 13;
  }

  // Task 340: Parental controls
  bool isContentAppropriate(String content, {int maxAge = 13}) {
    final blockedWords = ['spam', 'scam', 'hack', 'cheat'];
    return !blockedWords.any((w) => content.toLowerCase().contains(w));
  }
}

final securityService = SecurityService();
