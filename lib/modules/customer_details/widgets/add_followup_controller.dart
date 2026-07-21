import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_provider.dart';
import '../../../data/models/lead_details_models.dart';
import '../../../data/models/staff_model.dart';
import '../customer_details_controller.dart';
import '../../lead_details/lead_details_controller.dart';

class AddFollowupController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final dateTimeDisplayController = TextEditingController();
  
  final staffList = <Staff>[].obs;
  final selectedStaffId = Rxn<int>();

  final descriptionError = RxnString();
  final dateError = RxnString();
  final staffError = RxnString();

  final isLoading = false.obs;

  int customerId = 0;
  String relType = 'Customer';
  FollowUp? existingFollowup;
  final selectedDateTimeRx = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchStaff();
  }

  @override
  void onReady() {
    super.onReady();
    _populateFields();
  }

  Future<void> fetchStaff() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getStaffDropdown);
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body is String ? jsonDecode(response.bodyString!) : response.body;
        final staffData = StaffResponse.fromJson(data);
        if (staffData.status == true && staffData.resultData != null) {
          staffList.value = staffData.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching staff: $e');
    }
  }

  void _populateFields() {
    if (existingFollowup != null) {
      descriptionController.text = existingFollowup!.description;
      selectedStaffId.value = existingFollowup!.staff;
      
      try {
        final dt = DateTime.parse(existingFollowup!.date);
        selectedDateTimeRx.value = dt;
        final isoString = dt.toString(); // "yyyy-MM-dd HH:mm:ss.sss"
        final parts = isoString.split(' ');
        if (parts.length > 1) {
          dateController.text = parts[0];
          timeController.text = parts[1].substring(0, 8);
          dateTimeDisplayController.text = '${dateController.text} ${timeController.text}';
        }
      } catch (e) {
        // ignore
      }
    }
  }

  Future<void> submitFollowup() async {
    descriptionError.value = null;
    dateError.value = null;
    staffError.value = null;

    bool hasError = false;
    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'Description is required';
      hasError = true;
    }
    if (dateController.text.trim().isEmpty || timeController.text.trim().isEmpty) {
      dateError.value = 'Date & Time are required';
      hasError = true;
    }
    if (selectedStaffId.value == null) {
      staffError.value = 'Staff is required';
      hasError = true;
    }

    if (hasError) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      final isUpdate = existingFollowup != null;
      final formattedDate = '${dateController.text} ${timeController.text}';
      
      final payload = {
        if (isUpdate) "id": existingFollowup!.id,
        "description": descriptionController.text,
        "date": formattedDate,
        "staff": selectedStaffId.value,
        if (!isUpdate) "rel_id": customerId,
        if (!isUpdate) "rel_type": relType,
        if (!isUpdate) "creator": loginStaffId,
      };

      final endpoint = isUpdate ? ApiEndpoints.updateReminder : ApiEndpoints.addReminder;
      final response = await _apiProvider.post(endpoint, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
        Get.snackbar(
          'Success', 
          isUpdate ? 'Follow-Up updated successfully' : 'Follow-Up added successfully', 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
        // Refresh details
        if (Get.isRegistered<CustomerDetailsController>()) {
          Get.find<CustomerDetailsController>().fetchCustomerDetails();
        }
        if (Get.isRegistered<LeadDetailsController>()) {
          Get.find<LeadDetailsController>().fetchLeadDetails();
        }
      } else {
        Get.snackbar('Error', 'Failed to save follow-up',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save follow-up',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
