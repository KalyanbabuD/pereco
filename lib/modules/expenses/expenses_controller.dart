import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/expense_model.dart';

class ExpensesController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final expenses = <Expense>[].obs;
  final filteredExpenses = <Expense>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void searchExpenses(String query) {
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
}
