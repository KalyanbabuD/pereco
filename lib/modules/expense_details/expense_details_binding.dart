import 'package:get/get.dart';
import 'expense_details_controller.dart';

class ExpenseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseDetailsController>(() => ExpenseDetailsController());
  }
}
