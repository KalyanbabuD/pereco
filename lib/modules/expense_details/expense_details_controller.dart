import 'package:get/get.dart';
import '../../data/models/expense_model.dart';

class ExpenseDetailsController extends GetxController {
  late final Expense expense;

  @override
  void onInit() {
    super.onInit();
    expense = Get.arguments as Expense;
  }
}
