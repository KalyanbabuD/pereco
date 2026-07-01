import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../leads/leads_controller.dart';
import '../customers/customers_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<LeadsController>(() => LeadsController());
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}

