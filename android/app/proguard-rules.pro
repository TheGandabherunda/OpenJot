# ProGuard rules for a Flutter app with awesome_notifications and other dependencies

# ------------------------------
# General Flutter and Android Rules
# ------------------------------

# Preserve Flutter core classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve Flutter plugin registrants and method channels
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.EventChannel { *; }
-keep class io.flutter.plugin.common.BinaryMessenger { *; }

# Preserve AndroidX and legacy support libraries
-keep class androidx.** { *; }
-keep class android.support.v4.** { *; }
-keep class android.support.v7.** { *; }

# Preserve Android framework classes for notifications and intents
-keep class android.app.NotificationManager { *; }
-keep class android.app.NotificationChannel { *; }
-keep class android.app.Notification** { *; }
-keep class android.app.PendingIntent { *; }
-keep class android.content.Intent { *; }
-keep class android.os.Bundle { *; }

# Preserve Parcelable classes for Intent communication
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
    public int describeContents();
    public void writeToParcel(android.os.Parcel, int);
}

# Preserve Service, BroadcastReceiver, ContentProvider, and Activity subclasses
-keep public class * extends android.app.Service {
    public <init>(...);
    public android.os.IBinder onBind(android.content.Intent);
    public int onStartCommand(android.content.Intent, int, int);
}
-keep public class * extends android.content.BroadcastReceiver {
    public <init>(...);
    public void onReceive(android.content.Context, android.content.Intent);
}
-keep public class * extends android.content.ContentProvider {
    public <init>(...);
}
-keep public class * extends android.app.Activity {
    public <init>(...);
}

# Preserve classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Preserve resource classes
-keep class **.R$* { *; }
-keep class **.R$mipmap {
    public static final int ic_notification;
}
-keep class **.R$raw {
    public static final int *;
}
-keep class **.R$drawable {
    public static final int *;
}

# Preserve JNI methods and native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve serialization classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Preserve classes accessed via reflection
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# --------------------------------
# Awesome Notifications Rules
# --------------------------------

# Preserve all awesome_notifications classes, interfaces, and enums
-keep class com.awesome_notifications.** { *; }
-keep interface com.awesome_notifications.** { *; }
-keep enum com.awesome_notifications.** { *; }
-keep class com.awesome_notifications.core.** { *; }
-keep class com.awesome_notifications.core.models.** { *; }
-keep class com.awesome_notifications.core.receivers.** { *; }
-keep class com.awesome_notifications.core.services.** { *; }
-keep class * extends com.awesome_notifications.core.models.AbstractModel { *; }
-keep class * implements com.awesome_notifications.core.AwesomeNotificationsExtension { *; }

# Preserve specific awesome_notifications components
-keep class com.awesome_notifications.AwesomeNotificationsReceiver { *; }
-keep class com.awesome_notifications.AwesomeNotificationsService { *; }

# Suppress warnings for awesome_notifications
-dontwarn com.awesome_notifications.**

# --------------------------------
# Nothing Glyph Interface Rules
# --------------------------------

# Preserve all Nothing Glyph Interface classes, interfaces, and enums
-keep class com.nothing.** { *; }
-keep interface com.nothing.** { *; }
-keep enum com.nothing.** { *; }

# Suppress warnings for Nothing classes
-dontwarn com.nothing.**

# --------------------------------
# Firebase and Google Play Services
# --------------------------------

# Preserve Firebase and Google Play Services classes (if used)
# Note: For F-Droid, ensure proprietary dependencies are excluded or replaced
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# --------------------------------
# AndroidX Work Manager Rules
# --------------------------------

# Preserve Work Manager for background tasks
-keep class androidx.work.** { *; }
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }

# --------------------------------
# Dependency-Specific Rules
# --------------------------------

# Preserve dependencies used in pomodoro_controller.dart
-keep class dev.fluttercommunity.plus.androidintent.** { *; } # android_intent_plus
-keep class com.baseflow.flutter_timezone.** { *; } # flutter_timezone
-keep class com.jordanalcaraz.donotdisturb.** { *; } # do_not_disturb
-keep class io.flutter.plugins.hive.** { *; } # hive_flutter
-keep class get.** { *; } # get
-keep class com.example.torch_light.** { *; } # torch_light
-keep class com.wakelock_plus.** { *; } # wakelock_plus
-keep class fluttertoast.** { *; } # fluttertoast

# Suppress warnings for dependencies
-dontwarn dev.fluttercommunity.plus.androidintent.**
-dontwarn com.baseflow.flutter_timezone.**
-dontwarn com.jordanalcaraz.donotdisturb.**
-dontwarn io.flutter.plugins.hive.**
-dontwarn get.**
-dontwarn com.example.torch_light.**
-dontwarn com.wakelock_plus.**
-dontwarn fluttertoast.**

# --------------------------------
# Hive-Specific Rules
# --------------------------------

# Preserve Hive adapters and annotated fields
-keep class io.flutter.plugins.hive.** { *; }
-keep class * extends io.flutter.plugins.hive.HiveAdapter { *; }
-keepclassmembers class * {
    @io.flutter.plugins.hive.HiveField *;
    @io.flutter.plugins.hive.HiveKey *;
}

# --------------------------------
# Suppress General Warnings
# --------------------------------

# Suppress warnings for potentially missing classes
-dontwarn androidx.**
-dontwarn android.support.**
-dontwarn com.google.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**

# --------------------------------
# Debugging Options (Commented Out)
# --------------------------------

# Enable these for debugging ProGuard issues, but disable for production
#-printseeds proguard_seeds.txt
#-printusage proguard_usage.txt
#-printmapping proguard_mapping.txt
#-printconfiguration proguard_configuration.txt
#-verbose