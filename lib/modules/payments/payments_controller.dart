import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/payment_model.dart';

class PaymentsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final payments = <Payment>[].obs;
  final filteredPayments = <Payment>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  @override
  void onClose() {
    searchController.dispose();
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
      isLoading.value = true;
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
          filteredPayments.value = paymentResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching payments: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
