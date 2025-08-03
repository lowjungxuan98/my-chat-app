import 'package:flutter/material.dart';
import 'loading_overlay.dart';

/// Logout confirmation dialog with loading state
class LogoutDialog extends StatefulWidget {
  final Future<void> Function() onLogout;

  const LogoutDialog({
    super.key,
    required this.onLogout,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      loadingText: 'Logging out...',
      child: AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _handleLogout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Handle the logout process with loading state
  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onLogout();
      
      // Don't close dialog here - parent handles it
      // The dialog will be closed by the parent onLogout function
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }
}