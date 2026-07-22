import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_provider.dart';
import '../../../data/models/lead_model.dart';
import '../../../data/models/lead_source_model.dart';
import '../../../data/models/lead_status_model.dart';
import '../../../data/models/staff_model.dart';
import '../leads_controller.dart';

class AddLeadController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final isLoading = false.obs;

  // Existing Lead if in Edit mode
  Lead? existingLead;

  // Dropdown lists
  final sources = <LeadSource>[].obs;
  final staffList = <Staff>[].obs;
  final statuses = <LeadStatus>[].obs;

  // Form Fields
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final cityController = TextEditingController();

  // Selected values
  final selectedSourceId = Rxn<int>();
  final selectedStaffId = Rxn<int>();
  final selectedStatusId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    // Check if arguments were passed
    if (Get.arguments != null && Get.arguments is Lead) {
      existingLead = Get.arguments as Lead;
      prefillData();
    }
    fetchInitialData();
  }

  void prefillData() {
    if (existingLead != null) {
      nameController.text = existingLead!.name ?? '';
      mobileController.text = existingLead!.phonenumber ?? '';
      emailController.text = existingLead!.email ?? '';
      companyController.text = existingLead!.company ?? '';
      addressController.text = existingLead!.address ?? '';
      cityController.text = existingLead!.city ?? '';
      // Description is not part of the standard list model, might be empty here.

      selectedSourceId.value = existingLead!.sourceId;
      selectedStatusId.value = existingLead!.statusId;
      // Note: AssignedTo in Lead model is string in list, we might not have the ID directly unless we parse it.
      // If we don't have it, we leave it null.
    }
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([fetchSources(), fetchStaff(), fetchStatuses()]);
    isLoading.value = false;
  }

  Future<void> fetchSources() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getLeadSources);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String
            ? jsonDecode(res.bodyString!)
            : res.body;
        final model = LeadSourceResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          sources.value = model.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching lead sources: $e');
    }
  }

  Future<void> fetchStatuses() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getLeadStatus);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String
            ? jsonDecode(res.bodyString!)
            : res.body;
        final model = LeadStatusResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          statuses.value = model.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching lead statuses: $e');
    }
  }

  Future<void> fetchStaff() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getStaffDropdown);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String
            ? jsonDecode(res.bodyString!)
            : res.body;
        final model = StaffResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          staffList.value = model.resultData!;

          // Try to match existingLead assignedTo name if we couldn't get ID
          if (existingLead != null && selectedStaffId.value == null) {
            final staff = staffList.firstWhereOrNull(
              (s) => s.fullName == existingLead!.assignedTo,
            );
            if (staff != null) {
              selectedStaffId.value = staff.staffid;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching staff: $e');
    }
  }

  Future<void> submitLead() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (mobileController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Mobile number is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedSourceId.value == null) {
      Get.snackbar(
        'Error',
        'Source is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedStatusId.value == null) {
      Get.snackbar(
        'Error',
        'Status is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 1;

      final isEdit = existingLead != null;
      final endpoint = isEdit ? ApiEndpoints.updateLead : ApiEndpoints.addLead;

      final now = DateTime.now();
      final dateStr = now.toIso8601String().split('T').first;
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final Map<String, dynamic> payload = {
        "name": nameController.text.trim(),
        "company": companyController.text.trim(),
        "description": descriptionController.text.trim(),
        "country": 1,
        "zip": "",
        "city": cityController.text.trim(),
        "state": "",
        "address": addressController.text.trim(),
        "assigned": selectedStaffId.value ?? loginStaffId,
        "status": selectedStatusId.value,
        "source": selectedSourceId.value,
        "lastcontact": "$dateStr $timeStr",
        "dateassigned": dateStr,
        "email": emailController.text.trim(),
        "website": "",
        "phonenumber": mobileController.text.trim(),
        "addedfrom": loginStaffId,
      };
      
      if (isEdit) {
        payload["id"] = existingLead!.id;
      } else {
        payload["client_id"] = 0;
        payload["lead_value"] = 0;
        payload["active"] = 1;
      }
      
      print("payload: " + payload.toString());

      final response = await _apiProvider.post(endpoint, payload);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        Get.back(); // close bottom sheet
        Get.snackbar(
          'Success',
          isEdit ? 'Lead updated successfully' : 'Lead added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh list
        if (Get.isRegistered<LeadsController>()) {
          Get.find<LeadsController>().fetchLeads();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to save lead',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save lead',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
