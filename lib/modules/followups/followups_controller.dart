import 'dart:convert';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/reminder_model.dart';
import 'package:flutter/material.dart';

class FollowupsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final followups = <Reminder>[].obs;
  final filteredFollowups = <Reminder>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchFollowups();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void searchFollowups(String query) {
    if (query.isEmpty) {
      filteredFollowups.value = followups;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredFollowups.value = followups.where((f) {
        return (f.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (f.firstname?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (f.lastname?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchFollowups('');
  }

  Future<void> fetchFollowups() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.get('${ApiEndpoints.getReminders}?staffid=0');

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final reminderResponse = ReminderResponse.fromJson(jsonResponse);
        if (reminderResponse.status == true && reminderResponse.resultData != null) {
          followups.value = reminderResponse.resultData!;
          filteredFollowups.value = reminderResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching followups: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
