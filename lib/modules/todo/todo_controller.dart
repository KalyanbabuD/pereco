import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/todo_model.dart';
import '../../data/models/staff_model.dart';

class TodoController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final todos = <Todo>[].obs;
  final filteredTodos = <Todo>[].obs;
  final isLoading = true.obs;
  
  final staffList = <Staff>[].obs;
  
  // Dropdown states
  final selectedStaffId = 0.obs; // 0 means 'All'
  final selectedStatus = ''.obs; // '' means 'All', '1' means Completed, '0' means Pending
  
  final TextEditingController searchController = TextEditingController();
  final TextEditingController staffSearchController = TextEditingController();

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredTodos.length / itemsPerPage).ceil();

  List<Todo> get paginatedTodos {
    if (filteredTodos.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredTodos.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredTodos.sublist(
        startIndex,
        endIndex > filteredTodos.length ? filteredTodos.length : endIndex);
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

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void onClose() {
    searchController.dispose();
    staffSearchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _initData() async {
    await fetchStaffDropdown();
    await fetchTodos();
  }

  Future<void> fetchStaffDropdown() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getStaffDropdown);
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final staffResponse = StaffResponse.fromJson(jsonResponse);
        if (staffResponse.status == true && staffResponse.resultData != null) {
          staffList.value = staffResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching staff dropdown: $e');
    }
  }

  Future<void> fetchTodos() async {
    try {
      currentPage.value = 1;
      isLoading.value = true;

      // Construct URL based on selections
      String url = '${ApiEndpoints.getTodos}?staffid=${selectedStaffId.value}&finished=${selectedStatus.value}';
      
      final response = await _apiProvider.get(url);

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final todoResponse = TodoResponse.fromJson(jsonResponse);
        if (todoResponse.status == true && todoResponse.resultData != null) {
          todos.value = todoResponse.resultData!;
          _applyLocalSearch();
        } else {
          todos.clear();
          filteredTodos.clear();
        }
      } else {
        todos.clear();
        filteredTodos.clear();
      }
    } catch (e) {
      print('Error fetching todos: $e');
      todos.clear();
      filteredTodos.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTodoStatus(int todoid, int finished) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoints.updateTodoStatus,
        {'todoid': todoid, 'finished': finished},
      );
      if (response.statusCode == 200) {
        // Refetch todos to get updated list and datefinished
        clearSearch();
      }
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<bool> addTodo(String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      final response = await _apiProvider.post(
        ApiEndpoints.addTodo,
        {
          'description': description,
          'staffid': loginStaffId,
          'item_order': 1,
        },
      );
      
      bool isSuccess = false;
      if (!response.hasError) {
        isSuccess = true;
      }
      
      if (response.body != null) {
         try {
           final body = response.body is String ? jsonDecode(response.bodyString!) : response.body;
           if (body['Status'] == true || body['status'] == true) {
             isSuccess = true;
           } else if (body['Status'] == false || body['status'] == false) {
             isSuccess = false;
           }
         } catch (_) {}
      }

      if (isSuccess) {
        clearSearch();
        return true;
      }
    } catch (e) {
      print('Error adding todo: $e');
    }
    return false;
  }

  Future<bool> updateTodo(int todoid, String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      final response = await _apiProvider.post(
        ApiEndpoints.updateTodo,
        {
          'todoid': todoid,
          'description': description,
          'staffid': loginStaffId,
          'item_order': 1,
        },
      );
      
      bool isSuccess = false;
      if (!response.hasError) {
        isSuccess = true;
      }
      
      if (response.body != null) {
         try {
           final body = response.body is String ? jsonDecode(response.bodyString!) : response.body;
           if (body['Status'] == true || body['status'] == true) {
             isSuccess = true;
           } else if (body['Status'] == false || body['status'] == false) {
             isSuccess = false;
           }
         } catch (_) {}
      }

      if (isSuccess) {
        clearSearch();
        return true;
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
    return false;
  }

  Future<bool> deleteTodo(int todoid) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoints.deleteTodo,
        {'todoid': todoid},
      );
      
      bool isSuccess = false;
      if (!response.hasError) {
        isSuccess = true;
      }
      
      if (response.body != null) {
         try {
           final body = response.body is String ? jsonDecode(response.bodyString!) : response.body;
           if (body['Status'] == true || body['status'] == true) {
             isSuccess = true;
           } else if (body['Status'] == false || body['status'] == false) {
             isSuccess = false;
           }
         } catch (_) {}
      }

      if (isSuccess) {
        clearSearch();
        return true;
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
    return false;
  }

  void onStaffChanged(int? staffId) {
    if (staffId != null) {
      selectedStaffId.value = staffId;
      fetchTodos();
    }
  }

  void onStatusChanged(String? status) {
    if (status != null) {
      selectedStatus.value = status;
      fetchTodos();
    }
  }

  void searchTodos(String query) {
    _applyLocalSearch();
  }
  
  void _applyLocalSearch() {
    currentPage.value = 1;
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredTodos.value = todos;
    } else {
      filteredTodos.value = todos.where((todo) {
        return (todo.description?.toLowerCase().contains(query) ?? false) ||
            (todo.staffName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchTodos('');
    
    // Reset dropdowns to "All" and re-fetch when navigating
    selectedStaffId.value = 0;
    selectedStatus.value = '';
    fetchTodos();
  }
}
