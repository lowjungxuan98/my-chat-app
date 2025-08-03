import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../config/app_config.dart';

class HttpService {
  static Dio? _dio;
  static CookieJar? _cookieJar;

  /// Get the configured Dio instance with cookie support
  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    // Initialize cookie jar
    if (_cookieJar == null) {
      if (kIsWeb) {
        // For web, use default cookie jar
        _cookieJar = CookieJar();
      } else {
        // For mobile, use persistent cookie jar
        try {
          final appDocDir = await getApplicationDocumentsDirectory();
          final cookiePath = '${appDocDir.path}/.cookies/';
          _cookieJar = PersistCookieJar(
            storage: FileStorage(cookiePath),
          );
        } catch (e) {
          debugPrint('Failed to create persistent cookie jar: $e');
          _cookieJar = CookieJar();
        }
      }
    }

    // Create Dio instance
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.requestTimeout,
      sendTimeout: AppConfig.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Enable following redirects
      followRedirects: true,
      maxRedirects: 3,
    ));

    // Add cookie manager
    _dio!.interceptors.add(CookieManager(_cookieJar!));

    // Add logging interceptor for debugging
    if (kDebugMode) {
      _dio!.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // Add error handling interceptor
    _dio!.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('HTTP Error: ${error.message}');
        if (error.response != null) {
          debugPrint('Status Code: ${error.response!.statusCode}');
          debugPrint('Response Data: ${error.response!.data}');
        }
        handler.next(error);
      },
    ));

    return _dio!;
  }

  /// Clear all cookies (useful for logout)
  static Future<void> clearCookies() async {
    if (_cookieJar != null) {
      await _cookieJar!.deleteAll();
    }
  }

  /// Get cookies for debugging
  static Future<List<Cookie>> getCookies(String url) async {
    if (_cookieJar == null) return [];
    try {
      return await _cookieJar!.loadForRequest(Uri.parse(url));
    } catch (e) {
      debugPrint('Failed to load cookies: $e');
      return [];
    }
  }

  /// Reset the HTTP service (useful for testing)
  static void reset() {
    _dio?.close();
    _dio = null;
    _cookieJar = null;
  }
}

/// File storage implementation for persistent cookies
class FileStorage implements Storage {
  final String _path;

  FileStorage(this._path);

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    final dir = Directory(_path);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
  }

  @override
  Future<void> delete(String key) async {
    final file = File('$_path$key');
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in keys) {
      await delete(key);
    }
  }

  @override
  Future<String?> read(String key) async {
    final file = File('$_path$key');
    if (file.existsSync()) {
      return await file.readAsString();
    }
    return null;
  }

  @override
  Future<void> write(String key, String value) async {
    final file = File('$_path$key');
    await file.writeAsString(value);
  }
}