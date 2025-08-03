class AppConfig {
  // Backend URL - Update this to your actual backend URL
  // For local development with backend running on localhost:3000
  static const String baseUrl = 'http://localhost:3000';
  // For production, use your deployed backend URL:
  // static const String baseUrl = 'https://your-backend-domain.com';
  
  // Stream Chat API key - Get this from https://getstream.io/
  // Updated with actual API key from environment configuration
  static const String streamApiKey = 'exk2f6qzz7je';
  
  // API endpoints
  static const String loginEndpoint = '$baseUrl/api/auth/login';
  static const String registerEndpoint = '$baseUrl/api/auth/register';
  static const String logoutEndpoint = '$baseUrl/api/auth/logout';
  static const String meEndpoint = '$baseUrl/api/auth/me';
  static const String tokenEndpoint = '$baseUrl/api/token';
  static const String createChannelEndpoint = '$baseUrl/api/create-channel';
  static const String debugChannelsEndpoint = '$baseUrl/api/debug/channels';
  
  // Shared preferences keys
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';
  static const String userNameKey = 'userName';
  static const String isLoggedInKey = 'isLoggedIn';
  
  // Timeout durations
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
}