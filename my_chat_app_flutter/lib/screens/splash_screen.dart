import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/platform_service.dart';

/// Splash screen that handles app initialization and navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Initialize platform services
    await PlatformService.initialize();
    PlatformService.setupNotificationHandlers();
    
    // Wait for any ongoing auth operations to complete
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Initialize auth provider
    await authProvider.init();
    
    // Wait a bit more to ensure auth state is stable
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Navigate based on authentication status
    if (mounted) {
      if (authProvider.isAuthenticated && !authProvider.isLoading) {
        Navigator.of(context).pushReplacementNamed('/chat');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 100,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 24),
            const Text(
              'My Chat App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}