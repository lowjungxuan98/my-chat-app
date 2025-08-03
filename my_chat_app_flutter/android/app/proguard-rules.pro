# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in [sdk]/tools/proguard/proguard-android.txt

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# photo_manager package rules
-keep class com.fluttercandies.photo_manager.** { *; }

# Stream Chat rules
-keep class io.getstream.chat.** { *; }

# Glide rules (used by photo_manager)
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

# File picker rules
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Video player rules
-keep class io.flutter.plugins.videoplayer.** { *; }

# Image picker rules
-keep class io.flutter.plugins.imagepicker.** { *; }