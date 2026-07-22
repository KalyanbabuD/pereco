import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../leads/leads_controller.dart';
import '../customers/customers_controller.dart';
import '../proposal/proposal_controller.dart';
import '../followups/followups_controller.dart';
import '../payments/payments_controller.dart';
import '../products/products_controller.dart';
import '../expenses/expenses_controller.dart';
import '../todo/todo_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<LeadsController>(() => LeadsController(), fenix: true);
    Get.lazyPut<CustomersController>(() => CustomersController(), fenix: true);
    Get.lazyPut<ProposalController>(() => ProposalController(), fenix: true);
    Get.lazyPut<FollowupsController>(() => FollowupsController(), fenix: true);
    Get.lazyPut<PaymentsController>(() => PaymentsController(), fenix: true);
    Get.lazyPut<ProductsController>(() => ProductsController(), fenix: true);
    Get.lazyPut<ExpensesController>(() => ExpensesController(), fenix: true);
    Get.lazyPut<TodoController>(() => TodoController(), fenix: true);
  }
}

