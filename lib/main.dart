import 'dart:async';
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
import 'package:open_jot/app/core/services/notification_service.dart';
import 'package:open_jot/app/core/theme.dart';
import 'package:open_jot/app/routes/app_pages.dart';
import 'package:timezone/data/latest_all.dart' as tz; // Updated to latest_all to support all global timezones
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  try {
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    String timeZoneName = tzInfo.identifier;

    if (timeZoneName == 'Asia/Calcutta') {
      timeZoneName = 'Asia/Kolkata';
    }
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    if (kDebugMode) {
      print('Could not find location: $e. Falling back to UTC.');
    }
    // FIX: The correct IANA timezone string for UTC is 'Etc/UTC'
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  }

  await Get.putAsync<HiveService>(() async {
    final service = HiveService();
    return service.init();
  });

  final notificationService = await Get.putAsync<NotificationService>(() async {
    final service = NotificationService();
    return service.init();
  });

  await notificationService.ensureRemindersScheduled();
  await notificationService.checkForOnThisDayMemories();

  Get.lazyPut(AppLockService.new);

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
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<NotificationService>().checkForOnThisDayMemories();
    }
  }

  void handleInitialNotification() {
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
      title: 'OpenJot',
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