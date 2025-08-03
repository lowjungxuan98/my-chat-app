# My Chat App Flutter

A cross-platform chat application built with Flutter for iOS and Android, designed to work with the Next.js backend.

## Features

- **Authentication**: Email/password login and registration
- **Real-time Chat**: Powered by Stream Chat SDK
- **Cross-platform**: Native iOS and Android support
- **Responsive Design**: Optimized for both phones and tablets
- **Channel Management**: Create and join chat channels
- **Native Integration**: Platform-specific features and optimizations

## Architecture

The app follows a clean architecture pattern with:

- **Models**: Data models with JSON serialization
- **Services**: API communication and platform services
- **Providers**: State management using Provider pattern
- **Screens**: UI screens (Login, Register, Chat)
- **Widgets**: Reusable UI components
- **Utils**: Utility functions and validators

## Setup Instructions

### Prerequisites

1. Flutter SDK (>=3.8.1)
2. Dart SDK
3. iOS development: Xcode 14+ and iOS Simulator
4. Android development: Android Studio and Android SDK
5. Running Next.js backend (see main project)

### Installation

1. **Clone and navigate to the Flutter project:**
   ```bash
   cd my_chat_app_flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code:**
   ```bash
   dart run build_runner build
   ```

4. **Configure Stream Chat API:**
   - Go to [Stream.io](https://getstream.io/) and create an account
   - Create a new app and get your API key
   - Update `lib/config/app_config.dart`:
     ```dart
     static const String streamApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
     ```

5. **Configure backend URL:**
   - Update `lib/config/app_config.dart` with your backend URL:
     ```dart
     // For local development
     static const String baseUrl = 'http://localhost:3000';
     
     // For production
     static const String baseUrl = 'https://your-backend-domain.com';
     ```

6. **iOS Setup:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Running the App

1. **Start your backend server** (from the main project directory):
   ```bash
   npm run dev
   ```

2. **Run the Flutter app:**
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   
   # For a specific device
   flutter devices
   flutter run -d [device-id]
   ```

### Development Commands

- **Run tests:**
  ```bash
  flutter test
  ```

- **Build for release:**
  ```bash
  # iOS
  flutter build ios --release
  
  # Android
  flutter build apk --release
  flutter build appbundle --release
  ```

- **Analyze code:**
  ```bash
  flutter analyze
  ```

- **Format code:**
  ```bash
  dart format .
  ```

## Project Structure

```
lib/
├── config/           # App configuration
├── models/           # Data models
├── providers/        # State management
├── screens/          # UI screens
├── services/         # API and platform services
├── utils/            # Utility functions
├── widgets/          # Reusable UI components
└── main.dart         # App entry point

ios/
├── Runner/
│   └── AppDelegate.swift    # iOS-specific code

android/
├── app/src/main/kotlin/
│   └── MainActivity.kt      # Android-specific code
```

## Key Files

- **`lib/main.dart`**: App entry point with providers setup
- **`lib/config/app_config.dart`**: Configuration constants
- **`lib/providers/auth_provider.dart`**: Authentication state management
- **`lib/providers/chat_provider.dart`**: Chat state management
- **`lib/services/auth_service.dart`**: API communication for auth
- **`lib/services/chat_service.dart`**: API communication for chat
- **`lib/services/platform_service.dart`**: Native platform integration

## Native Features

### iOS (Swift)
- Push notification setup
- iOS-specific UI configurations
- Device token handling
- User notification center integration

### Android (Kotlin)
- Notification channel creation
- Device information access
- Material design optimizations
- Platform-specific method channels

## API Integration

The app integrates with the Next.js backend APIs:

- **POST** `/api/auth/login` - User login
- **POST** `/api/auth/register` - User registration
- **POST** `/api/auth/logout` - User logout
- **GET** `/api/auth/me` - Get current user
- **POST** `/api/token` - Get Stream Chat token
- **POST** `/api/create-channel` - Create/join channels

## State Management

Uses Provider pattern for state management:

- **AuthProvider**: Manages user authentication state
- **ChatProvider**: Manages Stream Chat connection and channels

## Error Handling

- Network error handling with retry logic
- User-friendly error messages
- Offline state management
- Form validation

## Security

- Password hashing using SHA-256 (same as backend)
- Secure local storage using SharedPreferences
- HTTP-only cookie session management
- Input validation and sanitization

## Performance

- Efficient list rendering with Stream Chat widgets
- Image caching for user avatars
- Optimized build configurations
- Platform-specific optimizations

## Troubleshooting

### Common Issues

1. **Stream API Key Error:**
   - Ensure you've set the correct API key in `app_config.dart`
   - Verify your Stream.io account and app settings

2. **Backend Connection Error:**
   - Check if your backend is running on the correct port
   - Update the `baseUrl` in `app_config.dart`
   - For iOS simulator, use your computer's IP address instead of localhost

3. **iOS Build Issues:**
   - Run `cd ios && pod install && cd ..`
   - Clean build: `flutter clean && flutter pub get`

4. **Android Build Issues:**
   - Check Android SDK and build tools are installed
   - Verify `android/app/build.gradle` configurations

### Debugging

- Use `flutter logs` to see real-time logs
- Enable debug mode in Stream Chat for detailed logs
- Use Flutter Inspector for UI debugging

## Contributing

1. Follow Flutter and Dart style guidelines
2. Run `flutter analyze` before submitting
3. Add tests for new features
4. Update documentation as needed

## License

This project is part of the My Chat App ecosystem.