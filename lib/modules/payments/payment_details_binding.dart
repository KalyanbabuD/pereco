import 'package:get/get.dart';
import 'payment_details_controller.dart';

class PaymentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentDetailsController>(() => PaymentDetailsController());
  }
}
