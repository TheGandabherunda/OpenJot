import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/routes/app_pages.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app/core/services/notification_service.dart';
import 'app/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database and set the local timezone
  tz.initializeTimeZones(); // FIX: Added await to ensure initialization completes
  try {
    String timeZoneName = await FlutterTimezone.getLocalTimezone();
    // Handle a known deprecated timezone name for compatibility
    if (timeZoneName == 'Asia/Calcutta') {
      timeZoneName = 'Asia/Kolkata';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    // If timezone lookup fails for any reason, fall back to UTC to prevent a crash.
    print("Could not find location: $e. Falling back to UTC.");
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // FIX: Made service initialization more explicit to resolve type inference error.
  await Get.putAsync<HiveService>(() async {
    final service = HiveService();
    return await service.init();
  });
  await Get.putAsync<NotificationService>(() async {
    final service = NotificationService();
    return await service.init();
  });

// Set default system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Determine initial route based on first launch status
  final hiveService = Get.find<HiveService>();
  final initialRoute =
  hiveService.isFirstLaunch ? AppPages.INITIAL : AppPages.HOME;

  runApp(
    ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MyApp(initialRoute: initialRoute);
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();

    // Set initial theme mode from saved settings
    ThemeMode themeMode;
    switch (hiveService.theme) {
      case 'Light':
        themeMode = ThemeMode.light;
        break;
      case 'Dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return GetMaterialApp(
      title: "OpenJot",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
    );
  }
}
