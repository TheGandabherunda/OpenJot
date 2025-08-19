import 'package:get/get.dart';
import 'package:open_jot/app/modules/settings/settings_controller.dart';

class SettingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsScreenController>(
      () => SettingsScreenController(),
    );
  }
}
