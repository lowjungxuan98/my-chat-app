import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import 'http_service.dart';

class AuthService {
  /// Login user with email and password
  static Future<LoginResponse?> login(String email, String password) async {
    try {
      final dio = await HttpService.getDio();
      
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        // Store user data locally
        await _storeUserData(loginResponse.user);
        
        debugPrint('Login successful, cookies should be stored automatically');
        return loginResponse;
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        throw Exception(errorResponse.error);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.response != null) {
        try {
          final errorResponse = ErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.error);
        } catch (_) {
          throw Exception('Login failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  static Future<RegisterResponse?> register(
      String email, String password, String? name) async {
    try {
      final dio = await HttpService.getDio();
      
      final requestData = {
        'email': email,
        'password': password,
      };
      
      if (name != null && name.isNotEmpty) {
        requestData['name'] = name;
      }

      final response = await dio.post(
        '/api/auth/register',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        
        // Store user data locally
        await _storeUserData(registerResponse.user);
        
        debugPrint('Registration successful, cookies should be stored automatically');
        return registerResponse;
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        throw Exception(errorResponse.error);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.response != null) {
        try {
          final errorResponse = ErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.error);
        } catch (_) {
          throw Exception('Registration failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user from server
  static Future<User?> getCurrentUser() async {
    try {
      final dio = await HttpService.getDio();
      
      final response = await dio.get('/api/auth/me');

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['user']);
        
        // Update local storage
        await _storeUserData(user);
        
        return user;
      } else if (response.statusCode == 401) {
        // User not authenticated, clear local data
        await clearUserData();
        return null;
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        throw Exception(errorResponse.error);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // User not authenticated, clear local data
        await clearUserData();
        return null;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.response != null) {
        try {
          final errorResponse = ErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.error);
        } catch (_) {
          throw Exception('Auth check failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      final dio = await HttpService.getDio();
      
      await dio.post('/api/auth/logout');
      
      debugPrint('Logout request completed');
    } on DioException catch (e) {
      // Even if logout fails on server, continue with local cleanup
      debugPrint('Logout request failed: ${e.message}');
    } catch (e) {
      // Even if logout fails on server, continue with local cleanup
      debugPrint('Logout request failed: $e');
    } finally {
      // Clear cookies and local data
      await HttpService.clearCookies();
      await clearUserData();
    }
  }

  /// Get Stream Chat token for authenticated user
  static Future<TokenResponse?> getStreamToken() async {
    try {
      final dio = await HttpService.getDio();
      
      // Debug: Check what cookies we're sending
      final cookies = await HttpService.getCookies('${AppConfig.baseUrl}/api/token');
      debugPrint('Cookies being sent to /api/token: ${cookies.map((c) => '${c.name}=${c.value}').join('; ')}');
      
      final response = await dio.post('/api/token');

      if (response.statusCode == 200) {
        return TokenResponse.fromJson(response.data);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        throw Exception(errorResponse.error);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Not authenticated - please login again');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout');
      } else if (e.response != null) {
        try {
          final errorResponse = ErrorResponse.fromJson(e.response!.data);
          throw Exception(errorResponse.error);
        } catch (_) {
          throw Exception('Token request failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Store user data in local storage
  static Future<void> _storeUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.userIdKey, user.userId);
    await prefs.setString(AppConfig.userEmailKey, user.email);
    await prefs.setString(AppConfig.userNameKey, user.name);
    await prefs.setBool(AppConfig.isLoggedInKey, true);
  }

  /// Get user data from local storage
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(AppConfig.userIdKey),
      'email': prefs.getString(AppConfig.userEmailKey),
      'name': prefs.getString(AppConfig.userNameKey),
    };
  }

  /// Check if user is logged in locally
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConfig.isLoggedInKey) ?? false;
  }

  /// Clear all user data from local storage
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.userIdKey);
    await prefs.remove(AppConfig.userEmailKey);
    await prefs.remove(AppConfig.userNameKey);
    await prefs.setBool(AppConfig.isLoggedInKey, false);
  }
}