import 'package:get/get.dart';
import 'package:tracker_run/app/base/base_bindings.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
    );
  }
}
