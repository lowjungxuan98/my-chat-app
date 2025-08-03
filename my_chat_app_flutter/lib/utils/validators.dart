class Validators {
  static const String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(_emailPattern).hasMatch(email);
  }

  /// Validate password strength
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validate email format with error message
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return null; // Name is optional
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  /// Validate channel name
  static String? validateChannelName(String? channelName) {
    if (channelName == null || channelName.trim().isEmpty) {
      return 'Channel name is required';
    }
    if (channelName.trim().length < 2) {
      return 'Channel name must be at least 2 characters long';
    }
    if (channelName.trim().length > 50) {
      return 'Channel name must be less than 50 characters';
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}