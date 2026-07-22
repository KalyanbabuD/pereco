import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_provider.dart';
import '../customer_details_controller.dart';
import '../../lead_details/lead_details_controller.dart';
import '../../../data/models/lead_details_models.dart';

class AddNoteController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  final descriptionController = TextEditingController();
  final descriptionError = RxnString();
  final isLoading = false.obs;

  int customerId = 0;
  String relType = 'Customer';
  Note? existingNote;

  @override
  void onReady() {
    super.onReady();
    if (existingNote != null) {
      descriptionController.text = existingNote!.description;
    }
  }

  Future<void> submitNote() async {
    descriptionError.value = null;

    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'Description is required';
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      final isUpdate = existingNote != null;

      final payload = {
        if (isUpdate) "id": existingNote!.id,
        "description": descriptionController.text,
        if (!isUpdate) "rel_id": customerId,
        if (!isUpdate) "rel_type": relType,
        if (!isUpdate) "addedfrom": loginStaffId,
      };

      final endpoint = isUpdate ? ApiEndpoints.updateNote : ApiEndpoints.addNote;
      final response = await _apiProvider.post(endpoint, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
        Get.snackbar(
          'Success', 
          'Note added successfully', 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
        // Refresh customer details to pull new notes
        if (Get.isRegistered<CustomerDetailsController>()) {
          Get.find<CustomerDetailsController>().fetchCustomerDetails();
        }
        if (Get.isRegistered<LeadDetailsController>()) {
          Get.find<LeadDetailsController>().fetchLeadDetails();
        }
      } else {
        Get.snackbar('Error', 'Failed to save note',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save note',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
