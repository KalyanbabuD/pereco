import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/expense_dropdown_models.dart';
import '../../data/models/expense_model.dart';
import 'expenses_controller.dart';

class AddExpenseController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final ExpensesController _expensesController = Get.find<ExpensesController>();
  
  final Expense? expense;
  
  AddExpenseController({this.expense});

  // Form fields
  final expenseNameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Dropdown search controllers
  final categorySearchController = TextEditingController();
  final customerSearchController = TextEditingController();
  final currencySearchController = TextEditingController();
  final taxSearchController = TextEditingController();
  final paymentModeSearchController = TextEditingController();

  // Selected values
  final selectedDate = Rxn<DateTime>();
  final selectedCategory = Rxn<int>();
  final selectedCustomer = Rxn<int>();
  final selectedCurrency = Rxn<int>();
  final selectedTax = Rxn<int>();
  final selectedPaymentMode = Rxn<int>();

  // Use dropdown lists from ExpensesController
  List<DropdownItem> get categories => _expensesController.categories;
  List<DropdownItem> get customers => _expensesController.customers;
  List<DropdownItem> get currencies => _expensesController.currencies;
  List<DropdownItem> get taxes => _expensesController.taxes;
  List<DropdownItem> get paymentModes => _expensesController.paymentModes;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    if (expense != null) {
      expenseNameController.text = expense!.expenseName ?? '';
      amountController.text = expense!.amount?.toString() ?? '';
      descriptionController.text = expense!.note ?? '';
      
      selectedCategory.value = expense!.category;
      selectedCustomer.value = expense!.clientid;
      selectedCurrency.value = expense!.currency;
      selectedTax.value = expense!.tax;
      if (expense!.paymentmode != null) {
        selectedPaymentMode.value = int.tryParse(expense!.paymentmode.toString());
      }
      
      if (expense!.date != null && expense!.date!.isNotEmpty) {
        selectedDate.value = DateTime.tryParse(expense!.date!);
      } else {
        selectedDate.value = DateTime.now();
      }
    } else {
      selectedDate.value = DateTime.now();
    }
  }

  @override
  void onClose() {
    expenseNameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    categorySearchController.dispose();
    customerSearchController.dispose();
    currencySearchController.dispose();
    taxSearchController.dispose();
    paymentModeSearchController.dispose();
    super.onClose();
  }

  Future<void> submitExpense() async {
    if (expenseNameController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedCategory.value == null) {
      Get.snackbar('Error', 'Please fill required fields (Name, Amount, Category)', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      String formattedDate = '';
      if (selectedDate.value != null) {
        formattedDate = '${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}';
      }
      
      final payload = {
        "category": selectedCategory.value,
        "currency": selectedCurrency.value,
        "amount": double.tryParse(amountController.text) ?? 0,
        "tax": selectedTax.value,
        "note": descriptionController.text,
        "expense_name": expenseNameController.text,
        "clientid": selectedCustomer.value,
        "paymentmode": selectedPaymentMode.value,
        "date": formattedDate
      };
      
      if (expense != null && expense!.id != null) {
        payload["id"] = expense!.id;
        payload["project_id"] = expense!.projectId ?? 0;
      }
      
      // Remove null values if API strict
      payload.removeWhere((key, value) => value == null);

      final isEdit = expense != null && expense!.id != null;
      final endpoint = isEdit ? ApiEndpoints.updateExpense : ApiEndpoints.addExpense;
      final response = await _apiProvider.post(endpoint, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
      } else {
        Get.snackbar('Error', 'Failed to ${isEdit ? 'update' : 'add'} expense', 
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to process expense', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
