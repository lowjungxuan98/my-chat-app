import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformService {
  static const MethodChannel _notificationChannel = 
      MethodChannel('com.mychatapp.notifications');

  /// Initialize platform-specific services
  static Future<void> initialize() async {
    try {
      if (Platform.isAndroid) {
        await _initializeAndroid();
      } else if (Platform.isIOS) {
        await _initializeIOS();
      }
    } catch (e) {
      debugPrint('Platform service initialization failed: $e');
    }
  }

  /// Initialize Android-specific services
  static Future<void> _initializeAndroid() async {
    try {
      // Create notification channel
      await _notificationChannel.invokeMethod('createNotificationChannel');
      
      debugPrint('Android platform services initialized');
    } catch (e) {
      debugPrint('Failed to initialize Android platform services: $e');
    }
  }

  /// Initialize iOS-specific services
  static Future<void> _initializeIOS() async {
    try {
      // iOS initialization is handled in AppDelegate.swift
      debugPrint('iOS platform services initialized');
    } catch (e) {
      debugPrint('Failed to initialize iOS platform services: $e');
    }
  }

  /// Get device information (Android)
  static Future<Map<String, dynamic>?> getDeviceInfo() async {
    if (!Platform.isAndroid) return null;
    
    try {
      final result = await _notificationChannel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      debugPrint('Failed to get device info: $e');
      return null;
    }
  }

  /// Set up notification handlers
  static void setupNotificationHandlers() {
    _notificationChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDeviceTokenReceived':
          final String token = call.arguments;
          debugPrint('Device token received: $token');
          // Store or send token to backend if needed
          break;
        case 'onNotificationTapped':
          final Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
          debugPrint('Notification tapped: $data');
          // Handle notification tap - navigate to specific chat/channel
          break;
        default:
          debugPrint('Unknown method call: ${call.method}');
      }
    });
  }

  /// Check if the app is running on a tablet
  static bool isTablet(double screenWidth) {
    return screenWidth > 768;
  }

  /// Get platform-specific app version
  static String getPlatformName() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }

  /// Platform-specific haptic feedback
  static Future<void> provideHapticFeedback() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Platform-specific vibration
  static Future<void> vibrate() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.heavyImpact();
    }
  }
}