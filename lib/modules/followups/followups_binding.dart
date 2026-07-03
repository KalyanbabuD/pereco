import 'package:get/get.dart';
import 'followups_controller.dart';

class FollowupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowupsController>(() => FollowupsController());
  }
}
