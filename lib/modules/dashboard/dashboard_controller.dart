import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/dashboard_response.dart';

import '../leads/leads_controller.dart';
import '../customers/customers_controller.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final dashboardData = Rxn<DashboardData>();
  final userName = ''.obs;

  final ApiProvider _apiProvider = Get.put(ApiProvider());

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().clearSearch();
    }
    if (Get.isRegistered<CustomersController>()) {
      Get.find<CustomersController>().clearSearch();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final staffId = prefs.getInt('staffid');
      final firstName = prefs.getString('firstname') ?? '';
      final lastName = prefs.getString('lastname') ?? '';
      
      userName.value = '$firstName $lastName'.trim();
      
      if (staffId == null) {
        errorMessage.value = 'User not logged in';
        isLoading.value = false;
        return;
      }
      
      final response = await _apiProvider.get('${ApiEndpoints.getDashboardData}?staffid=$staffId');
      
      if (response.statusCode == 200 && response.body != null) {
        final dashboardResponse = DashboardResponse.fromJson(response.body);
        
        if (dashboardResponse.status == true && dashboardResponse.resultData != null) {
          dashboardData.value = dashboardResponse.resultData;
        } else {
          errorMessage.value = dashboardResponse.message ?? 'Failed to load dashboard data';
        }
      } else {
        errorMessage.value = 'Server error. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
