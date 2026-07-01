import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    
    // Request Interceptor
    httpClient.addRequestModifier<dynamic>((request) {
      // Add headers if needed
      request.headers['Content-Type'] = 'application/json';
      
      if (kDebugMode) {
        print('================ REQUEST ================');
        print('URL: ${request.url}');
        print('METHOD: ${request.method}');
        print('HEADERS: ${request.headers}');
        print('=========================================');
      }
      return request;
    });
    
    // Response Interceptor
    httpClient.addResponseModifier((request, response) {
      if (kDebugMode) {
        print('================ RESPONSE ===============');
        print('URL: ${request.url}');
        print('STATUS: ${response.statusCode}');
        print('BODY: ${response.body}');
        print('=========================================');
      }

      // Handle global errors if needed
      if (response.hasError) {
        // You can handle 401, 500, etc. here
      }
      return response;
    });
    
    super.onInit();
  }
}
