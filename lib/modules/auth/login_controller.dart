import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../routes/app_routes.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/login_response.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  
  final emailError = RxnString();
  final passwordError = RxnString();

  final ApiProvider _apiProvider = Get.put(ApiProvider());

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      emailController.text = 'siva@perennialcode.in';
      passwordController.text = 'admin123';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
    }
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    emailError.value = null;
    passwordError.value = null;
    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Please enter email';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Please enter password';
      isValid = false;
    }

    if (!isValid) return;

    if (isLoading.value) return;
    
    isLoading.value = true;
    
    try {
      final response = await _apiProvider.post(
        ApiEndpoints.login,
        {
          "Email": emailController.text.trim(),
          "Password": passwordController.text.trim()
        }
      );

      if (response.statusCode == 200 && response.bodyString != null) {
        // Safely decode the JSON response
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final loginResponse = LoginResponse.fromJson(jsonResponse);
        
        if (loginResponse.status == true && loginResponse.resultData != null) {
          Get.snackbar('Success', loginResponse.message ?? 'Login successful',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
          
          // Store data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('staffid', loginResponse.resultData!.staffId ?? 0);
          await prefs.setString('email', loginResponse.resultData!.email ?? '');
          await prefs.setString('firstname', loginResponse.resultData!.firstName ?? '');
          await prefs.setString('lastname', loginResponse.resultData!.lastName ?? '');
          
          Get.offNamed(Routes.DASHBOARD);
        } else {
          Get.snackbar('Error', loginResponse.message ?? 'Login failed',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Server error. Please try again.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

