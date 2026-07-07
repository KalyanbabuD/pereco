import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/org_settings_response.dart';

class SettingsController extends GetxController {
  final ApiProvider _apiProvider = Get.put(ApiProvider());

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final orgSettings = Rxn<OrgSettingsData>();

  @override
  void onInit() {
    super.onInit();
    fetchOrgSettings();
  }

  Future<void> fetchOrgSettings() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiProvider.get(ApiEndpoints.getOrgSettings);

      if (response.statusCode == 200 && response.body != null) {
        final settingsResponse = OrgSettingsResponse.fromJson(response.body);

        if (settingsResponse.status == true && settingsResponse.resultData != null) {
          orgSettings.value = settingsResponse.resultData;
        } else {
          errorMessage.value = settingsResponse.message ?? 'Failed to load organization settings';
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
}
