import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/expense_dropdown_models.dart';

class ExpensesController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final expenses = <Expense>[].obs;
  final filteredExpenses = <Expense>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  // Dropdown lists for Add Expense
  final categories = <DropdownItem>[].obs;
  final customers = <DropdownItem>[].obs;
  final currencies = <DropdownItem>[].obs;
  final taxes = <DropdownItem>[].obs;
  final paymentModes = <DropdownItem>[].obs;

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredExpenses.length / itemsPerPage).ceil();

  List<Expense> get paginatedExpenses {
    if (filteredExpenses.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredExpenses.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredExpenses.sublist(
        startIndex,
        endIndex > filteredExpenses.length ? filteredExpenses.length : endIndex);
  }

  void goToPage(int page) {
    currentPage.value = page;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
    fetchDropdownData();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void searchExpenses(String query) {
    currentPage.value = 1;
    if (query.isEmpty) {
      filteredExpenses.value = expenses;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredExpenses.value = expenses.where((expense) {
        return (expense.expenseName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (expense.clientName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (expense.note?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchExpenses('');
  }

  Future<void> fetchExpenses() async {
    try {
      currentPage.value = 1;
      isLoading.value = true;

      final response = await _apiProvider.get(ApiEndpoints.getExpenses);

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final expenseResponse = ExpenseResponse.fromJson(jsonResponse);
        if (expenseResponse.status == true && expenseResponse.resultData != null) {
          expenses.value = expenseResponse.resultData!;
          filteredExpenses.value = expenseResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDropdownData() async {
    try {
      // Fetch Categories
      final catResponse = await _apiProvider.get(ApiEndpoints.getExpenseCategories);
      if (catResponse.statusCode == 200) {
        final data = DropdownResponse.fromJson(catResponse.body);
        categories.value = data.resultData ?? [];
      }

      // Fetch Customers
      final custResponse = await _apiProvider.get(ApiEndpoints.getCustomers);
      if (custResponse.statusCode == 200) {
        final data = DropdownResponse.fromJson(custResponse.body);
        customers.value = data.resultData ?? [];
      }

      // Fetch Currencies
      final currResponse = await _apiProvider.get(ApiEndpoints.getCurrencies);
      if (currResponse.statusCode == 200) {
        final data = DropdownResponse.fromJson(currResponse.body);
        currencies.value = data.resultData ?? [];
      }

      // Fetch Taxes
      final taxResponse = await _apiProvider.get(ApiEndpoints.getTaxes);
      if (taxResponse.statusCode == 200) {
        final data = DropdownResponse.fromJson(taxResponse.body);
        taxes.value = data.resultData ?? [];
      }

      // Fetch Payment Modes
      final pmResponse = await _apiProvider.get(ApiEndpoints.getPaymentModes);
      if (pmResponse.statusCode == 200) {
        final data = DropdownResponse.fromJson(pmResponse.body);
        paymentModes.value = data.resultData ?? [];
      }
    } catch (e) {
      print('Error fetching dropdowns: $e');
    }
  }
}
