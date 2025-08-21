import 'package:get/get.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final _hiveService = Get.find<HiveService>();

  void navigateToHome() {
    // Set the flag to false so onboarding doesn't show again
    _hiveService.setFirstLaunch(false);
    Get.offNamed(Routes.HOME);
  }
}
