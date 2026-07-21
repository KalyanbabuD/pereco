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
  final currentFilter = ''.obs;

  // KPIs
  final activeClients = 0.obs;
  final totalClients = 0.obs;
  final remindersCount = 0.obs;
  final proposalsCount = 0.obs;

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredCustomers.length / itemsPerPage).ceil();

  List<Customer> get paginatedCustomers {
    if (filteredCustomers.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredCustomers.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredCustomers.sublist(
        startIndex,
        endIndex > filteredCustomers.length ? filteredCustomers.length : endIndex);
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) currentPage.value--;
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
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    fetchCustomersCounts();
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
    _applyFilters();
  }

  void searchCustomers(String query) {
    _applyFilters();
  }

  void _applyFilters() {
    currentPage.value = 1;
    final query = searchController.text.toLowerCase();
    
    filteredCustomers.value = customers.where((customer) {
      // Status Filter
      bool matchesStatus = true;
      if (currentFilter.value == 'Active') {
        matchesStatus = customer.active == 1 || customer.active == '1';
      } else if (currentFilter.value == 'Inactive') {
        matchesStatus = customer.active != 1 && customer.active != '1';
      }
      
      // Search Filter
      bool matchesSearch = true;
      if (query.isNotEmpty) {
        matchesSearch = (customer.company?.toLowerCase().contains(query) ?? false) ||
            (customer.city?.toLowerCase().contains(query) ?? false) ||
            (customer.phonenumber?.toLowerCase().contains(query) ?? false) ||
            (customer.contactName?.toLowerCase().contains(query) ?? false);
      }
      
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void clearSearch() {
    searchController.clear();
    _applyFilters();
  }

  Future<void> fetchCustomers() async {
    try {
      currentPage.value = 1;
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

  Future<void> fetchCustomersCounts() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getCustomersCounts);
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        if (jsonResponse['Status'] == true && jsonResponse['ResultData'] != null) {
          final resultData = jsonResponse['ResultData'] as List;
          if (resultData.isNotEmpty) {
            final data = resultData[0];
            activeClients.value = data['ActiveClients'] ?? 0;
            totalClients.value = data['TotalClients'] ?? 0;
            remindersCount.value = data['Reminders'] ?? 0;
            proposalsCount.value = data['Proposals'] ?? 0;
          }
        }
      }
    } catch (e) {
      print('Error fetching customer counts: $e');
    }
  }
}
