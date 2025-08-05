import 'package:get/get.dart';
import 'package:open_jot/app/routes/app_routes.dart'; // Import your app routes

class OnboardingController extends GetxController {
  void navigateToHome() {
    Get.offNamed(Routes.HOME);
  }
}
