import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_provider.dart';
import 'customers_controller.dart';

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
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 1;

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
        "addedfrom": loginStaffId,
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
        int? newUserId;
        dynamic responseData = response.body;

        if (responseData is String) {
          try {
            responseData = jsonDecode(responseData);
          } catch (e) {
            newUserId = int.tryParse(responseData.replaceAll(RegExp(r'[^0-9]'), ''));
          }
        }

        if (responseData is Map) {
          if (responseData.containsKey('id')) {
            newUserId = int.tryParse(responseData['id'].toString());
          } else if (responseData.containsKey('userid')) {
            newUserId = int.tryParse(responseData['userid'].toString());
          } else if (responseData.containsKey('clientId')) {
            newUserId = int.tryParse(responseData['clientId'].toString());
          } else if (responseData.containsKey('Status') && responseData['ResultData'] != null) {
            if (responseData['ResultData'] is Map && responseData['ResultData'].containsKey('id')) {
              newUserId = int.tryParse(responseData['ResultData']['id'].toString());
            } else {
              newUserId = int.tryParse(responseData['ResultData'].toString());
            }
          }
        } else if (responseData is int) {
          newUserId = responseData;
        }

        if (newUserId != null) {
          final contactPayload = {
            "userid": newUserId,
            "firstname": firstNameController.text,
            "lastname": lastNameController.text,
            "email": emailController.text,
            "phonenumber": phoneController.text.isNotEmpty ? phoneController.text : contactPhoneController.text,
            "title": titleController.text,
            "is_primary": 1,
            "active": 1
          };
          await _apiProvider.post(ApiEndpoints.addContact, contactPayload);
        }

        if (Get.isRegistered<CustomersController>()) {
          Get.find<CustomersController>().fetchCustomers();
          Get.find<CustomersController>().fetchCustomersCounts();
        }

        Get.back(result: true);
        Get.snackbar('Success', 'Customer added successfully',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
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
