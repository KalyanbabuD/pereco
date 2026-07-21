import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_provider.dart';
import '../../../data/models/customer_model.dart';
import '../customer_details_controller.dart';

class AddContactController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final titleController = TextEditingController();

  final firstNameError = RxnString();
  final isLoading = false.obs;

  int customerId = 0;
  Contact? existingContact;

  @override
  void onReady() {
    super.onReady();
    _populateFields();
  }

  void _populateFields() {
    if (existingContact != null) {
      firstNameController.text = existingContact!.firstname ?? '';
      lastNameController.text = existingContact!.lastname ?? '';
      emailController.text = existingContact!.email ?? '';
      phoneController.text = existingContact!.phonenumber ?? '';
      titleController.text = existingContact!.title ?? '';
    }
  }

  Future<void> submitContact() async {
    firstNameError.value = null;

    if (firstNameController.text.trim().isEmpty) {
      firstNameError.value = 'First name is required';
      return;
    }

    try {
      isLoading.value = true;
      final isUpdate = existingContact != null;
      final payload = {
        if (isUpdate) "id": existingContact!.id,
        if (!isUpdate) "userid": customerId,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "email": emailController.text,
        "phonenumber": phoneController.text,
        "title": titleController.text,
        "is_primary": existingContact?.isPrimary ?? 1,
        "active": existingContact?.active ?? 1,
      };

      final endpoint = isUpdate ? ApiEndpoints.updateContact : ApiEndpoints.addContact;
      final response = await _apiProvider.post(endpoint, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
        Get.snackbar(
          'Success', 
          isUpdate ? 'Contact updated successfully' : 'Contact added successfully', 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
        // Refresh contacts
        if (Get.isRegistered<CustomerDetailsController>()) {
          Get.find<CustomerDetailsController>().fetchCustomerDetails();
        }
      } else {
        Get.snackbar('Error', 'Failed to save contact',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save contact',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
