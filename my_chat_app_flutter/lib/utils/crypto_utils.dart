import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// Hash password using SHA-256 (same as the backend)
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate MD5 hash for user ID generation (same as backend)
  static String generateMd5Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Generate user ID from email (same logic as backend)
  static String generateUserId(String email) {
    final hash = generateMd5Hash(email);
    return 'user_${hash.substring(0, 8)}';
  }
}