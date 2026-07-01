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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  void searchLeads(String query) {
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
}
