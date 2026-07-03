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
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<LeadsController>(() => LeadsController());
    Get.lazyPut<CustomersController>(() => CustomersController());
    Get.lazyPut<ProposalController>(() => ProposalController());
    Get.lazyPut<FollowupsController>(() => FollowupsController());
    Get.lazyPut<PaymentsController>(() => PaymentsController());
    Get.lazyPut<ProductsController>(() => ProductsController());
    Get.lazyPut<ExpensesController>(() => ExpensesController());
    Get.lazyPut<TodoController>(() => TodoController());
  }
}

