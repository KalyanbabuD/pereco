import 'dart:convert';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/reminder_model.dart';
import '../../data/models/staff_model.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowupsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final followups = <Reminder>[].obs;
  final filteredFollowups = <Reminder>[].obs;
  final isLoading = true.obs;
  
  // Dependencies for Add/Edit form
  final staffList = <Staff>[].obs;
  final customersList = <Customer>[].obs;
  final leadsList = <Lead>[].obs;
  
  final TextEditingController searchController = TextEditingController();
  final TextEditingController filterSearchController = TextEditingController();

  // Filter states
  final isFilterVisible = false.obs;
  final filterType = 'All'.obs; // 'All', 'Lead', 'Customer'
  final selectedFilterId = RxnInt();

  void onFilterTypeChanged(String type) {
    filterType.value = type;
    selectedFilterId.value = null;
    if (type == 'All') {
      fetchFollowups();
    }
  }

  void onFilterEntitySelected(int id) {
    selectedFilterId.value = id;
    fetchFollowups();
  }

  @override
  void onInit() {
    super.onInit();
    fetchFollowups();
    fetchDependencies();
  }

  @override
  void onClose() {
    searchController.dispose();
    filterSearchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredFollowups.length / itemsPerPage).ceil();

  List<Reminder> get paginatedFollowups {
    if (filteredFollowups.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredFollowups.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredFollowups.sublist(
        startIndex,
        endIndex > filteredFollowups.length ? filteredFollowups.length : endIndex);
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void goToPage(int page) {
    currentPage.value = page;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void searchFollowups(String query) {
    currentPage.value = 1;
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
    fetchFollowups();
  }

  Future<void> fetchFollowups() async {
    try {
      currentPage.value = 1;
      isLoading.value = true;
      
      String url = '${ApiEndpoints.getReminders}?staffid=0';
      if (filterType.value != 'All' && selectedFilterId.value != null) {
        url += '&rel_id=${selectedFilterId.value}&rel_type=${filterType.value}';
      }
      
      final response = await _apiProvider.get(url);

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

  Future<void> fetchDependencies() async {
    try {
      // Fetch Staff
      final staffResponse = await _apiProvider.get(ApiEndpoints.getStaffDropdown);
      print('--- staffResponse status: ${staffResponse.statusCode}');
      if (staffResponse.statusCode == 200 && staffResponse.body != null) {
        print('--- staffResponse body type: ${staffResponse.body.runtimeType}');
        try {
          final jsonMap = staffResponse.body is String ? jsonDecode(staffResponse.bodyString!) : staffResponse.body;
          final staffData = StaffResponse.fromJson(jsonMap);
          print('--- staffData status: ${staffData.status}, count: ${staffData.resultData?.length}');
          if (staffData.status == true && staffData.resultData != null) {
            staffList.value = staffData.resultData!;
          }
        } catch (e) {
          print('--- Error parsing staffData: $e');
        }
      }

      // Fetch Customers
      final customersResponse = await _apiProvider.get(ApiEndpoints.getCustomers);
      if (customersResponse.statusCode == 200 && customersResponse.body != null) {
        final customersData = CustomerResponse.fromJson(customersResponse.body is String ? jsonDecode(customersResponse.bodyString!) : customersResponse.body);
        if (customersData.status == true && customersData.resultData != null) {
          customersList.value = customersData.resultData!;
        }
      }

      // Fetch Leads
      final leadsResponse = await _apiProvider.get(ApiEndpoints.getLeads);
      if (leadsResponse.statusCode == 200 && leadsResponse.body != null) {
        final leadsData = LeadResponse.fromJson(leadsResponse.body is String ? jsonDecode(leadsResponse.bodyString!) : leadsResponse.body);
        if (leadsData.status == true && leadsData.resultData != null) {
          leadsList.value = leadsData.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching dependencies: $e');
    }
  }

  Future<bool> addReminder(String description, String date, String relType, int relId, int staffId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      final response = await _apiProvider.post(
        ApiEndpoints.addReminder,
        {
          'description': description,
          'date': date,
          'rel_id': relId,
          'rel_type': relType,
          'staff': staffId,
          'creator': loginStaffId,
        },
      );
      if (response.statusCode == 200) {
        clearSearch();
        return true;
      }
    } catch (e) {
      print('Error adding reminder: $e');
    }
    return false;
  }

  Future<bool> updateReminder(int id, String description, String date, int staffId) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoints.updateReminder,
        {
          'id': id,
          'description': description,
          'date': date,
          'staff': staffId,
        },
      );
      if (response.statusCode == 200) {
        clearSearch();
        return true;
      }
    } catch (e) {
      print('Error updating reminder: $e');
    }
    return false;
  }
}
