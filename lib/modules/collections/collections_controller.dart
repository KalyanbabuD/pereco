import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../data/models/credit_note_model.dart';
import '../../../data/models/customer_model.dart';

class CollectionsController extends GetxController {
  var creditNotes = <CreditNote>[].obs;
  var filteredCreditNotes = <CreditNote>[].obs;
  var customers = <Customer>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  TextEditingController searchController = TextEditingController();

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredCreditNotes.length / itemsPerPage).ceil();

  List<CreditNote> get paginatedCreditNotes {
    if (filteredCreditNotes.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredCreditNotes.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredCreditNotes.sublist(
        startIndex,
        endIndex > filteredCreditNotes.length ? filteredCreditNotes.length : endIndex);
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

  // Add form controllers
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController customerSearchController = TextEditingController();
  var selectedCustomerId = Rxn<int>();
  
  var visibleNotes = <int>{}.obs;
  var editingCreditNoteId = Rxn<int>();

  void toggleNoteVisibility(int id) {
    if (visibleNotes.contains(id)) {
      visibleNotes.remove(id);
    } else {
      visibleNotes.add(id);
    }
  }

  void openEditCreditNote(CreditNote cn) {
    editingCreditNoteId.value = cn.id;
    selectedCustomerId.value = cn.clientid;
    amountController.text = cn.total ?? '';
    if (cn.date != null && cn.date!.length >= 10) {
      dateController.text = cn.date!.substring(0, 10);
    }
    noteController.text = cn.clientnote ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchCreditNotes();
    fetchCustomers();
  }

  Future<void> fetchCreditNotes() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await http.get(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.getCreditNotes));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final creditNoteResponse = CreditNoteResponse.fromJson(decoded);
        if (creditNoteResponse.status == true && creditNoteResponse.resultData != null) {
          creditNotes.value = creditNoteResponse.resultData!;
          filteredCreditNotes.value = creditNotes;
        } else {
          errorMessage('Failed to load credit notes.');
        }
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.getCustomers));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final customerResponse = CustomerResponse.fromJson(decoded);
        if (customerResponse.status == true && customerResponse.resultData != null) {
          customers.value = customerResponse.resultData!;
        }
      }
    } catch (e) {
      debugPrint('Error fetching customers: $e');
    }
  }

  void searchCreditNotes(String query) {
    currentPage.value = 1;
    if (query.isEmpty) {
      filteredCreditNotes.value = creditNotes;
    } else {
      filteredCreditNotes.value = creditNotes.where((cn) {
        final prefixNumber = '${cn.prefix ?? ''}${cn.number ?? ''}'.toLowerCase();
        final clientName = cn.clientName?.toLowerCase() ?? '';
        final amount = cn.total?.toLowerCase() ?? '';
        final lowerQuery = query.toLowerCase();
        return prefixNumber.contains(lowerQuery) || clientName.contains(lowerQuery) || amount.contains(lowerQuery);
      }).toList();
    }
  }

  Future<void> addCreditNote() async {
    if (selectedCustomerId.value == null || amountController.text.isEmpty || dateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      var payload = {
        "clientid": selectedCustomerId.value,
        "total": double.tryParse(amountController.text) ?? 0,
        "date": dateController.text,
        "addedfrom": 49, // Defaulting to 49 as per requirement
        "clientnote": noteController.text
      };
      
      if (editingCreditNoteId.value != null) {
        payload["id"] = editingCreditNoteId.value;
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.addCreditNote),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        final status = decoded['Status'] ?? decoded['status'];
        final isSuccess = status == true || status.toString().toLowerCase() == 'true' || status == 1;
        
        if (isSuccess) {
          Get.back(); // close bottom sheet
          Get.snackbar('Success', decoded['Message'] ?? 'Credit note added successfully.', backgroundColor: Colors.green, colorText: Colors.white);
          // Clear form
          selectedCustomerId.value = null;
          editingCreditNoteId.value = null;
          amountController.clear();
          dateController.clear();
          noteController.clear();
          // Refresh list
          fetchCreditNotes();
        } else {
          Get.snackbar('Error', decoded['Message'] ?? 'Failed to add credit note.', backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        debugPrint('Failed to add credit note. Status: ${response.statusCode}, Body: ${response.body}');
        Get.snackbar('Error', 'Server Error: ${response.statusCode} - ${response.body}', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error adding credit note: $e');
      Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
