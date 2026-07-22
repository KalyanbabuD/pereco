import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/lead_details_models.dart'; // Re-use FollowUp and Note models
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_provider.dart';

class CustomerDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Observables
  final isLoading = false.obs;
  final customerDetails = Rx<Customer?>(null);
  final contacts = <Contact>[].obs;
  final followUps = <FollowUp>[].obs;
  final notes = <Note>[].obs;

  final followUpsSearch = ''.obs;
  final notesSearch = ''.obs;
  final contactsSearch =
      ''.obs; // Assuming search for contacts tab if it was a list

  int customerId = 0;

  @override
  void onInit() {
    super.onInit();

    int initialIndex = 0;
    if (Get.arguments != null) {
      if (Get.arguments['initialTabIndex'] != null) {
        initialIndex = Get.arguments['initialTabIndex'] as int;
      }
      if (Get.arguments['customerId'] != null) {
        customerId = Get.arguments['customerId'] as int;
      }
    }

    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: initialIndex,
    );

    fetchCustomerDetails();
  }

  Future<void> deleteNote(int noteId) async {
    try {
      final response = await _apiProvider.post(ApiEndpoints.deleteNote, {'id': noteId});
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        notes.removeWhere((note) => note.id == noteId);
        Get.snackbar('Success', 'Note deleted successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to delete note', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete note', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchCustomerDetails() async {
    if (customerId == 0) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final staffId = prefs.getInt('staffid') ?? 0;

      // 1. Fetch Customer Profile & Contact Details
      final profileResponse = await _apiProvider.get(
        '${ApiEndpoints.getCustomerDetails}?CusId=$customerId',
      );
      if (profileResponse.statusCode == 200 && profileResponse.body != null) {
        Map<String, dynamic> jsonResponse;
        if (profileResponse.body is Map<String, dynamic>) {
          jsonResponse = profileResponse.body;
        } else {
          jsonResponse = jsonDecode(profileResponse.bodyString!);
        }

        final customerResponse = CustomerResponse.fromJson(jsonResponse);
        if (customerResponse.status == true &&
            customerResponse.resultData != null &&
            customerResponse.resultData!.isNotEmpty) {
          customerDetails.value = customerResponse.resultData!.first;
        }
      }

      // 2. Fetch Follow-Ups
      final followUpsResponse = await _apiProvider.get(
        '${ApiEndpoints.getReminders}?rel_id=$customerId&rel_type=Customer&staffid=0',
      );
      if (followUpsResponse.statusCode == 200 &&
          followUpsResponse.body != null) {
        Map<String, dynamic> jsonResponse;
        if (followUpsResponse.body is Map<String, dynamic>) {
          jsonResponse = followUpsResponse.body;
        } else {
          jsonResponse = jsonDecode(followUpsResponse.bodyString!);
        }

        if (jsonResponse['Status'] == true &&
            jsonResponse['ResultData'] != null) {
          final list = jsonResponse['ResultData'] as List;
          followUps.value = list.map((e) => FollowUp.fromJson(e)).toList();
        }
      }

      // 3. Fetch Notes
      final notesResponse = await _apiProvider.get(
        '${ApiEndpoints.getNotes}?rel_id=$customerId&rel_type=Customer',
      );
      if (notesResponse.statusCode == 200 && notesResponse.body != null) {
        Map<String, dynamic> jsonResponse;
        if (notesResponse.body is Map<String, dynamic>) {
          jsonResponse = notesResponse.body;
        } else {
          jsonResponse = jsonDecode(notesResponse.bodyString!);
        }

        if (jsonResponse['Status'] == true &&
            jsonResponse['ResultData'] != null) {
          final list = jsonResponse['ResultData'] as List;
          notes.value = list.map((e) => Note.fromJson(e)).toList();
        }
      }

      // 4. Fetch Contacts
      final contactsResponse = await _apiProvider.get(
        '${ApiEndpoints.getContacts}?userid=$customerId',
      );
      if (contactsResponse.statusCode == 200 && contactsResponse.body != null) {
        Map<String, dynamic> jsonResponse;
        if (contactsResponse.body is Map<String, dynamic>) {
          jsonResponse = contactsResponse.body;
        } else {
          jsonResponse = jsonDecode(contactsResponse.bodyString!);
        }

        if (jsonResponse['Status'] == true &&
            jsonResponse['ResultData'] != null) {
          final list = jsonResponse['ResultData'] as List;
          contacts.value = list.map((e) => Contact.fromJson(e)).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customer details');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper for date formatting
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString.split('T').first;
    }
  }
}
