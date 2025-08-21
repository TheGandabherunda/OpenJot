import 'package:get/get.dart';
import 'package:open_jot/app/modules/app_lock/app_lock_screen.dart';
import 'package:open_jot/app/modules/onboarding/onboarding_binding.dart';
import 'package:open_jot/app/modules/onboarding/onboarding_view.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._(); // Private constructor to prevent instantiation

  // Define the initial route of the application
  static const INITIAL = Routes.ONBOARDING;
  static const HOME = Routes.HOME;
  static const APP_LOCK = Routes.APP_LOCK;

  // List of all GetPage objects, defining routes, pages, and their bindings
  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(), // Placeholder for HomeView
      binding: HomeBinding(), // Placeholder for HomeBinding
    ),
    GetPage(
      name: Routes.APP_LOCK,
      page: () => const AppLockScreen(),
    ),
    // Add other GetPage entries here for new screens
  ];
}
