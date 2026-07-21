import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/lead_model.dart';

class LeadsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final leads = <Lead>[].obs;
  final filteredLeads = <Lead>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  // KPIs
  final activeLeads = 0.obs;
  final totalLeads = 0.obs;
  final remindersCount = 0.obs;
  final proposalsCount = 0.obs;

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredLeads.length / itemsPerPage).ceil();

  List<Lead> get paginatedLeads {
    if (filteredLeads.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredLeads.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredLeads.sublist(
        startIndex,
        endIndex > filteredLeads.length ? filteredLeads.length : endIndex);
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
    fetchLeads();
    fetchLeadCounts();
  }

  void searchLeads(String query) {
    currentPage.value = 1;
    if (query.isEmpty) {
      filteredLeads.value = leads;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredLeads.value = leads.where((lead) {
        return (lead.name?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (lead.email?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (lead.phonenumber?.toLowerCase().contains(lowercaseQuery) ??
                false) ||
            (lead.company?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (lead.city?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchLeads('');
  }

  Future<void> fetchLeads() async {
    try {
      currentPage.value = 1;
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final staffId = prefs.getInt('staffid');

      final response = await _apiProvider.get(ApiEndpoints.getLeads);

      if (response.statusCode == 200 && response.body != null) {
        // Parse JSON
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final leadResponse = LeadResponse.fromJson(jsonResponse);
        if (leadResponse.status == true && leadResponse.resultData != null) {
          leads.value = leadResponse.resultData!;
          filteredLeads.value =
              leadResponse.resultData!; // Initialize filtered leads
        }
      }
    } catch (e) {
      print('Error fetching leads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeadCounts() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getLeadCounts);
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
            activeLeads.value = data['ActiveLeads'] ?? 0;
            totalLeads.value = data['TotalLeads'] ?? 0;
            remindersCount.value = data['Reminders'] ?? 0;
            proposalsCount.value = data['Proposals'] ?? 0;
          }
        }
      }
    } catch (e) {
      print('Error fetching lead counts: $e');
    }
  }
}
