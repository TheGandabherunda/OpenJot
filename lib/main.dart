import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/services/app_lock_service.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/routes/app_pages.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app/core/services/notification_service.dart';
import 'app/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  try {
    String timeZoneName = await FlutterTimezone.getLocalTimezone();
    if (timeZoneName == 'Asia/Calcutta') {
      timeZoneName = 'Asia/Kolkata';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    if (kDebugMode) {
      print("Could not find location: $e. Falling back to UTC.");
    }
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  await Get.putAsync<HiveService>(() async {
    final service = HiveService();
    return await service.init();
  });
  // --- MODIFIED: Await the init and then check for memories ---
  final notificationService = await Get.putAsync<NotificationService>(() async {
    final service = NotificationService();
    return await service.init();
  });
  // Check for "On This Day" memories after services are initialized
  await notificationService.checkForOnThisDayMemories();
  // --- END MODIFIED ---

  Get.lazyPut(() => AppLockService());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final hiveService = Get.find<HiveService>();
  String initialRoute;
  if (hiveService.appLockEnabled) {
    initialRoute = AppPages.APP_LOCK;
  } else if (hiveService.isFirstLaunch) {
    initialRoute = AppPages.INITIAL;
  } else {
    initialRoute = AppPages.HOME;
  }

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

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    handleInitialNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --- NEW: Check for "On This Day" when app comes to foreground ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<NotificationService>().checkForOnThisDayMemories();
    }
  }

  // --- NEW: Handle notification tap from terminated state ---
  void handleInitialNotification() {
    // Use a post-frame callback to ensure the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (NotificationService.initialPayload != null) {
        try {
          final payloadData = jsonDecode(NotificationService.initialPayload!)
          as Map<String, dynamic>;
          if (payloadData['type'] == 'on_this_day') {
            final dateStr = payloadData['date'] as String;
            final date = DateTime.parse(dateStr);
            NotificationService.handleOnThisDayTap(date);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding initial payload: $e');
          }
        }
        // Clear the payload after handling it
        NotificationService.initialPayload = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = Get.find<HiveService>();

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
      initialRoute: widget.initialRoute,
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
