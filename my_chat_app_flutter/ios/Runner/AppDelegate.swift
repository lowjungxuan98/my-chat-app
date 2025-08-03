import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure iOS-specific settings
    configureIOSSettings()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureIOSSettings() {
    // Set up iOS-specific configurations
    
    // Configure notification settings
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        if granted {
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
        }
      }
    }
    
    // Configure app appearance
    if #available(iOS 13.0, *) {
      // Use system appearance
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let window = windowScene.windows.first {
        window.overrideUserInterfaceStyle = .unspecified
      }
    }
  }
  
  // Handle push notifications
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Convert device token to string and send to Flutter
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    
    // Send to Flutter via method channel if needed
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "com.mychatapp.notifications", binaryMessenger: controller.binaryMessenger)
      channel.invokeMethod("onDeviceTokenReceived", arguments: tokenString)
    }
  }
  
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register for remote notifications: \(error)")
  }
  
  // MARK: - UNUserNotificationCenterDelegate
  
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notification even when app is in foreground
    completionHandler([.alert, .badge, .sound])
  }
  
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // Handle notification tap
    let userInfo = response.notification.request.content.userInfo
    
    // Send notification data to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "com.mychatapp.notifications", binaryMessenger: controller.binaryMessenger)
      channel.invokeMethod("onNotificationTapped", arguments: userInfo)
    }
    
    completionHandler()
  }
}