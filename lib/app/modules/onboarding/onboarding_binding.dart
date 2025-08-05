import 'package:get/get.dart';
import 'package:open_jot/app/modules/onboarding/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily inject the OnboardingController, meaning it's created only when needed.
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
    );
  }
}
