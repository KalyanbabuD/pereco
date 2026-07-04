import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_provider.dart';

class AddCustomerController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Info Tab
  final companyController = TextEditingController();
  final websiteController = TextEditingController();
  final vatController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final addressController = TextEditingController();

  final companyError = RxnString();

  // Contact Person Tab
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final titleController = TextEditingController();
  final emailController = TextEditingController();

  // Billing Tab
  final billingStreetController = TextEditingController();
  final billingCityController = TextEditingController();
  final billingStateController = TextEditingController();
  final billingZipController = TextEditingController();

  final shippingStreetController = TextEditingController();
  final shippingCityController = TextEditingController();
  final shippingStateController = TextEditingController();
  final shippingZipController = TextEditingController();

  final RxBool sameAsBilling = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes to copy billing to shipping
    sameAsBilling.listen((isSame) {
      if (isSame) {
        shippingStreetController.text = billingStreetController.text;
        shippingCityController.text = billingCityController.text;
        shippingStateController.text = billingStateController.text;
        shippingZipController.text = billingZipController.text;
      }
    });
  }

  Future<void> submitCustomer() async {
    companyError.value = null;

    if (companyController.text.trim().isEmpty) {
      companyError.value = 'Company name is required';
      return;
    }

    try {
      isLoading.value = true;
      final payload = {
        "company": companyController.text,
        "phonenumber": phoneController.text,
        "country": 1, // Defaulting to 1 based on payload
        "city": cityController.text,
        "state": stateController.text,
        "zip": zipController.text,
        "address": addressController.text,
        "website": websiteController.text,
        "leadid": 0,
        "addedfrom": 49,
        "active": 1,
        "billing_street": billingStreetController.text,
        "billing_city": billingCityController.text,
        "billing_state": billingStateController.text,
        "billing_zip": billingZipController.text,
        "shipping_street": shippingStreetController.text,
        "shipping_city": shippingCityController.text,
        "shipping_state": shippingStateController.text,
        "shipping_zip": shippingZipController.text,
      };

      final response = await _apiProvider.post(ApiEndpoints.addCustomer, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
      } else {
        Get.snackbar('Error', 'Failed to add customer',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add customer',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    companyController.dispose();
    websiteController.dispose();
    vatController.dispose();
    phoneController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    addressController.dispose();
    
    firstNameController.dispose();
    lastNameController.dispose();
    contactPhoneController.dispose();
    titleController.dispose();
    emailController.dispose();

    billingStreetController.dispose();
    billingCityController.dispose();
    billingStateController.dispose();
    billingZipController.dispose();
    
    shippingStreetController.dispose();
    shippingCityController.dispose();
    shippingStateController.dispose();
    shippingZipController.dispose();
    super.onClose();
  }
}
