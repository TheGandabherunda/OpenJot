import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:open_jot/app/routes/app_pages.dart';
import 'app/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default system UI overlay style for the entire app
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make status bar background transparent
    statusBarIconBrightness: Brightness.light, // Set status bar icons to light (for dark content underneath)
    systemNavigationBarColor: Colors.black, // Example: black navigation bar color
    systemNavigationBarIconBrightness: Brightness.light, // Set navigation bar icons to light
  ));

  runApp(
    ScreenUtilInit(
      designSize: Size(402, 874), // Match your design tool (Figma/Adobe)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "OpenJot",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
    );
  }
}
