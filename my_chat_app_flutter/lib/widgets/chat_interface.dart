import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'create_channel_dialog.dart';
import 'logout_dialog.dart';
import 'channel_page.dart';

/// Main chat interface widget that displays the channel list
class ChatInterface extends StatelessWidget {
  const ChatInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chat App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateChannelDialog(context),
            tooltip: 'Create Channel',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamChannelListView(
        controller: StreamChannelListController(
          client: StreamChat.of(context).client,
          filter: Filter.in_(
            'members',
            [StreamChat.of(context).currentUser!.id],
          ),
          channelStateSort: const [SortOption.desc('last_message_at')],
        ),
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StreamChannel(
                channel: channel,
                child: const ChannelPage(),
              ),
            ),
          );
        },
        itemBuilder: (context, channels, index, tile) {
          return tile;
        },
        emptyBuilder: (context) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No channels yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Create a channel to start chatting!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        errorBuilder: (context, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading channels: $error'),
            ],
          ),
        ),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Show the create channel dialog
  void _showCreateChannelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateChannelDialog(),
    );
  }

  /// Handle logout action
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => LogoutDialog(
        onLogout: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final chatProvider = Provider.of<ChatProvider>(context, listen: false);
          
          // Capture navigator before async operations to avoid context.mounted issues
          final navigator = Navigator.of(context, rootNavigator: true);
          
          // Close the dialog first to avoid navigation conflicts
          Navigator.of(dialogContext).pop();
          
          // Add a small delay to ensure dialog is closed
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Disconnect chat first
          await chatProvider.disconnect();
          
          // Then logout and ensure it completes
          await authProvider.logout();
          
          // Wait a bit to ensure logout cleanup is complete
          await Future.delayed(const Duration(milliseconds: 200));
          
          // Navigate directly to login screen using captured navigator
          // This avoids context.mounted issues after async operations
          navigator.pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        },
      ),
    );
  }
}