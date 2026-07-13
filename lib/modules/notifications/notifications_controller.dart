import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/notification_model.dart';
import '../../routes/app_routes.dart';
import '../dashboard/dashboard_controller.dart';

class NotificationsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final receivedNotifications = <NotificationItem>[].obs;
  final sentNotifications = <NotificationItem>[].obs;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final staffId = prefs.getInt('staffid');

      if (staffId == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      final response = await _apiProvider.get('${ApiEndpoints.getNotifications}?userid=$staffId');

      if (response.statusCode == 200 && response.body != null) {
        final notificationResponse = NotificationResponse.fromJson(response.body);
        if (notificationResponse.status) {
          receivedNotifications.value = notificationResponse.receivedNotifications;
          sentNotifications.value = notificationResponse.sentNotifications;
        } else {
          errorMessage.value = 'Failed to load notifications';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<NotificationItem> get filteredReceivedNotifications {
    if (searchQuery.value.isEmpty) {
      return receivedNotifications;
    }
    final lowerQuery = searchQuery.value.toLowerCase();
    return receivedNotifications.where((item) {
      return item.description.toLowerCase().contains(lowerQuery) ||
             item.fromStaffName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<NotificationItem> get filteredSentNotifications {
    if (searchQuery.value.isEmpty) {
      return sentNotifications;
    }
    final lowerQuery = searchQuery.value.toLowerCase();
    return sentNotifications.where((item) {
      return item.description.toLowerCase().contains(lowerQuery) ||
             item.toStaffName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      
      String _twoDigits(int n) => n >= 10 ? "$n" : "0$n";
      final ampm = date.hour >= 12 ? 'PM' : 'AM';
      final hr = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final timeString = '${_twoDigits(hr)}:${_twoDigits(date.minute)} $ampm';
      
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}, $timeString';
    } catch (e) {
      return dateString;
    }
  }

  void handleNotificationTap(NotificationItem item) {
    if (item.link.isNotEmpty) {
      if (item.link.startsWith('/view-lead/')) {
        final parts = item.link.split('/');
        if (parts.length > 2) {
          final leadId = int.tryParse(parts.last);
          if (leadId != null) {
            Get.toNamed(Routes.LEAD_DETAILS, arguments: {'leadId': leadId});
            return;
          }
        }
      } else if (item.link == '/reminders') {
        Get.until((route) => route.settings.name == Routes.DASHBOARD);
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().changeTabIndex(5);
        }
      } else {
        Get.snackbar('Notice', 'Navigation to ${item.link} is not fully implemented yet.', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
