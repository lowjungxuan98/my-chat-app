import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  StreamChatClient? _client;
  User? _streamUser;
  bool _isConnected = false;
  bool _isLoading = false;
  String? _error;

  StreamChatClient? get client => _client;
  User? get streamUser => _streamUser;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize Stream Chat client and connect user
  Future<bool> initializeChat() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Get Stream Chat token from backend
      final tokenResponse = await AuthService.getStreamToken();
      if (tokenResponse == null) {
        throw Exception('Failed to get Stream Chat token');
      }

      // Create Stream Chat client
      _client = StreamChatClient(AppConfig.streamApiKey);

      // Connect user to Stream Chat
      await _client!.connectUser(
        User(
          id: tokenResponse.user.id,
          name: tokenResponse.user.name,
          image: tokenResponse.user.image,
        ),
        tokenResponse.token,
      );

      _streamUser = _client!.state.currentUser;
      _isConnected = true;
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Disconnect from Stream Chat
  Future<void> disconnect() async {
    try {
      await _client?.disconnectUser();
      _client = null;
      _streamUser = null;
      _isConnected = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Create a new channel
  Future<bool> createChannel({
    required String channelName,
    required List<String> userIds,
  }) async {
    if (!_isConnected || _client == null) {
      _setError('Not connected to chat');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final channelId = ChatService.generateChannelId(channelName);
      
      // Create channel via backend API
      final response = await ChatService.createChannel(
        channelId: channelId,
        userIds: userIds,
        channelName: channelName,
      );

      if (response != null && response.success) {
        notifyListeners();
        return true;
      }
      
      throw Exception(response?.message ?? 'Failed to create channel');
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Join an existing channel
  Future<bool> joinChannel(String channelId, List<String> userIds) async {
    if (!_isConnected || _client == null) {
      _setError('Not connected to chat');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Join channel via backend API
      final response = await ChatService.createChannel(
        channelId: channelId,
        userIds: userIds,
      );

      if (response != null && response.success) {
        notifyListeners();
        return true;
      }
      
      throw Exception(response?.message ?? 'Failed to join channel');
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get user's channels
  List<Channel> getUserChannels() {
    if (!_isConnected || _client == null || _streamUser == null) {
      return [];
    }

    // This would typically be handled by the StreamChat UI components
    // But we can provide this method for custom implementations
    return [];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}