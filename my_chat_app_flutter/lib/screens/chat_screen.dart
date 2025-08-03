import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_interface.dart';

/// Main chat screen that handles chat initialization and displays the chat interface
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize chat when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.initializeChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // Show loading while initializing
        if (chatProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show error if initialization failed
        if (chatProvider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to initialize chat: ${chatProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => chatProvider.initializeChat(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show message if not connected
        if (!chatProvider.isConnected || chatProvider.client == null) {
          return const Scaffold(
            body: Center(
              child: Text('Connecting to chat...'),
            ),
          );
        }

        // Main chat interface - StreamChat is now provided by main.dart
        return const ChatInterface();
      },
    );
  }
}