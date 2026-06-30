import 'package:get/get.dart';
import 'estimations_controller.dart';

class EstimationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EstimationsController>(() => EstimationsController());
  }
}
