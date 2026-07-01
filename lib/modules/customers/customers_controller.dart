import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/customer_model.dart';

class CustomersController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final customers = <Customer>[].obs;
  final filteredCustomers = <Customer>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.value = customers;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredCustomers.value = customers.where((customer) {
        return (customer.company?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (customer.city?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (customer.phonenumber?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (customer.contactName?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchCustomers('');
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;

      final response = await _apiProvider.get(ApiEndpoints.getCustomers);

      if (response.statusCode == 200 && response.body != null) {
        // Parse JSON
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final customerResponse = CustomerResponse.fromJson(jsonResponse);
        if (customerResponse.status == true && customerResponse.resultData != null) {
          customers.value = customerResponse.resultData!;
          filteredCustomers.value = customerResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching customers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
