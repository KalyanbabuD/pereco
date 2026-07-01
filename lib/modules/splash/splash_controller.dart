import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final staffId = prefs.getInt('staffid');

    if (staffId != null) {
      Get.offNamed(Routes.DASHBOARD);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
