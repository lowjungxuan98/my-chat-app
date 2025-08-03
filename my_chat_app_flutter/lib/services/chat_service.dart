import 'package:dio/dio.dart';
import '../models/api_response.dart';
import 'http_service.dart';

class ChatService {
  /// Create a new channel
  static Future<CreateChannelResponse?> createChannel({
    required String channelId,
    required List<String> userIds,
    String channelType = 'messaging',
    String? channelName,
  }) async {
    try {
      final dio = await HttpService.getDio();
      
      final requestData = {
        'channelId': channelId,
        'userIds': userIds,
        'channelType': channelType,
      };
      
      if (channelName != null && channelName.isNotEmpty) {
        requestData['channelName'] = channelName;
      }

      final response = await dio.post(
        '/api/create-channel',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return CreateChannelResponse.fromJson(response.data);
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
          throw Exception('Create channel failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get debug information about channels (for development)
  static Future<Map<String, dynamic>?> getDebugChannels() async {
    try {
      final dio = await HttpService.getDio();
      
      final response = await dio.get('/api/debug/channels');

      if (response.statusCode == 200) {
        return response.data;
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
          throw Exception('Debug channels failed: ${e.response!.statusMessage}');
        }
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Generate a channel ID from channel name
  static String generateChannelId(String channelName) {
    return channelName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');
  }
}