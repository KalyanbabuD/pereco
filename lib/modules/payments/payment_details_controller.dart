import 'dart:convert';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/payment_details_model.dart';

class PaymentDetailsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final isLoading = true.obs;
  final paymentDetails = Rxn<PaymentDetails>();
  late int paymentId;

  @override
  void onInit() {
    super.onInit();
    paymentId = Get.arguments['paymentId'];
    fetchPaymentDetails();
  }

  Future<void> fetchPaymentDetails() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.get('${ApiEndpoints.getPaymentDetails}?PaymentId=$paymentId');

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final detailsResponse = PaymentDetailsResponse.fromJson(jsonResponse);
        if (detailsResponse.status == true) {
          paymentDetails.value = detailsResponse.resultData;
        }
      }
    } catch (e) {
      print('Error fetching payment details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
