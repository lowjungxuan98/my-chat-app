import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Backend URL - Update this to your actual backend URL
  // For local development with backend running on localhost:3000
  static final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
  // For production, use your deployed backend URL:
  // static const String baseUrl = 'https://your-backend-domain.com';
  
  // Stream Chat API key - Get this from https://getstream.io/
  // Loaded from .env file
  static String get streamApiKey => dotenv.env['NEXT_PUBLIC_STREAM_API_KEY'] ?? '';
  
  // API endpoints
  static final String loginEndpoint = '$baseUrl/api/auth/login';
  static final String registerEndpoint = '$baseUrl/api/auth/register';
  static final String logoutEndpoint = '$baseUrl/api/auth/logout';
  static final String meEndpoint = '$baseUrl/api/auth/me';
  static final String tokenEndpoint = '$baseUrl/api/token';
  static final String createChannelEndpoint = '$baseUrl/api/create-channel';
  static final String debugChannelsEndpoint = '$baseUrl/api/debug/channels';
  
  // Shared preferences keys
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';
  static const String userNameKey = 'userName';
  static const String isLoggedInKey = 'isLoggedIn';
  
  // Timeout durations
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
}