import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/invoice_model.dart';
import '../../data/models/expense_dropdown_models.dart';

class PaymentsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  var payments = <Payment>[].obs;
  var filteredPayments = <Payment>[].obs;
  var isLoading = false.obs;
  var isListLoading = false.obs;

  // Dropdown lists
  var invoices = <Invoice>[].obs;
  var paymentModes = <DropdownItem>[].obs;

  // Form Controllers
  var amountController = TextEditingController();
  var paymentMethodController = TextEditingController();
  var dateController = TextEditingController();
  var noteController = TextEditingController();
  var transactionIdController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController invoiceSearchController = TextEditingController();
  
  var selectedInvoiceId = Rxn<int>();
  var selectedPaymentModeId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
    fetchInvoices();
    fetchPaymentModes();
  }

  @override
  void onClose() {
    searchController.dispose();
    invoiceSearchController.dispose();
    amountController.dispose();
    paymentMethodController.dispose();
    dateController.dispose();
    noteController.dispose();
    transactionIdController.dispose();
    super.onClose();
  }

  void searchPayments(String query) {
    if (query.isEmpty) {
      filteredPayments.value = payments;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredPayments.value = payments.where((p) {
        return (p.invoicePrefix?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.transactionid?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.note?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.amount?.toString().contains(lowercaseQuery) ?? false) ||
               (p.clientName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.paymentModeName?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchPayments('');
  }

  Future<void> fetchPayments() async {
    try {
      isListLoading.value = true;
      final response = await _apiProvider.get(ApiEndpoints.getPayments);

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final paymentResponse = PaymentResponse.fromJson(jsonResponse);
        if (paymentResponse.status == true && paymentResponse.resultData != null) {
          payments.value = paymentResponse.resultData!;
          searchPayments(searchController.text);
        }
      }
    } catch (e) {
      debugPrint('Error fetching payments: $e');
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> fetchInvoices() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.getInvoices);
      if (response.statusCode == 200 && response.body != null) {
        final invoiceResponse = InvoiceResponse.fromJson(response.body);
        invoices.assignAll(invoiceResponse.resultData ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching invoices: $e");
    }
  }

  Future<void> fetchPaymentModes() async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.paymentsGetPaymentModes);
      if (response.statusCode == 200 && response.body != null) {
        final data = DropdownResponse.fromJson(response.body);
        paymentModes.assignAll(data.resultData ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching payment modes: $e");
    }
  }

  Future<void> addPayment() async {
    if (selectedInvoiceId.value == null || amountController.text.isEmpty || selectedPaymentModeId.value == null || dateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        "invoiceid": selectedInvoiceId.value,
        "amount": double.tryParse(amountController.text) ?? 0,
        "paymentmode": selectedPaymentModeId.value,
        "paymentmethod": paymentMethodController.text,
        "date": dateController.text,
        "note": noteController.text,
        "transactionid": transactionIdController.text
      };

      final response = await _apiProvider.post(ApiEndpoints.addPayment, body);

      if ((response.statusCode == 200 || response.statusCode == 201) && response.body != null) {
        Map<String, dynamic> decoded;
        if (response.body is Map<String, dynamic>) {
          decoded = response.body;
        } else {
          decoded = jsonDecode(response.bodyString!);
        }

        if (decoded['Status'] == true) {
          Get.back(); // close bottom sheet
          Get.snackbar('Success', decoded['Message'] ?? 'Payment added successfully.', backgroundColor: Colors.green, colorText: Colors.white);
          
          // Clear form
          selectedInvoiceId.value = null;
          selectedPaymentModeId.value = null;
          amountController.clear();
          paymentMethodController.clear();
          dateController.clear();
          noteController.clear();
          transactionIdController.clear();
          
          fetchPayments();
        } else {
          Get.snackbar('Error', decoded['Message'] ?? 'Failed to add payment.', backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to add payment. Code: ${response.statusCode}', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
