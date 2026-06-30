import 'package:get/get.dart';
import 'lead_details_controller.dart';

class LeadDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadDetailsController>(() => LeadDetailsController());
  }
}
