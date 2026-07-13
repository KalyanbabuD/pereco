import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';
import '../../core/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../dashboard/dashboard_controller.dart';
import '../../routes/app_routes.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: AppColors.cardDarkBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 16.0),
          //     child: Center(
          //       child: InkWell(
          //         onTap: () {
          //           // Mark all as read functionality
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //           decoration: BoxDecoration(
          //             color: Colors.white.withOpacity(0.1),
          //             borderRadius: BorderRadius.circular(4),
          //           ),
          //           child: const Row(
          //             children: [
          //               Icon(Icons.check, size: 16, color: Colors.white),
          //               SizedBox(width: 4),
          //               Text('Mark All Read', style: TextStyle(color: Colors.white, fontSize: 12)),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelColor: AppColors.primaryOrange,
                unselectedLabelColor: AppColors.greyText,
                indicatorColor: AppColors.primaryOrange,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                tabs: [
                  Obx(
                    () => Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Received (${controller.receivedNotifications.length})',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send, size: 18),
                          const SizedBox(width: 8),
                          Text('Sent (${controller.sentNotifications.length})'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF4F6F8),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        onChanged: controller.setSearchQuery,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNotificationList(isReceived: true),
                  _buildNotificationList(isReceived: false),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: GetBuilder<DashboardController>(
          init: Get.isRegistered<DashboardController>() ? Get.find<DashboardController>() : Get.put(DashboardController()),
          builder: (dashController) {
            return Obx(
              () => ClipPath(
                clipper: _BottomNavClipper(),
                child: Container(
                  color: AppColors.cardDarkBlue,
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: dashController.currentIndex.value < 4 ? dashController.currentIndex.value : 0,
                      selectedItemColor: dashController.currentIndex.value < 4 ? Colors.white : Colors.white54,
                      unselectedItemColor: Colors.white54,
                      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                      onTap: (index) {
                        dashController.changeTabIndex(index);
                        Get.until((route) => route.settings.name == Routes.DASHBOARD);
                      },
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
                        BottomNavigationBarItem(icon: Icon(Icons.headset_mic), label: 'Leads'),
                        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Todo'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList({required bool isReceived}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final notifications = isReceived
          ? controller.filteredReceivedNotifications
          : controller.filteredSentNotifications;

      if (notifications.isEmpty) {
        return const Center(child: Text("No notifications found"));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchNotifications,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(notifications[index], isReceived);
          },
        ),
      );
    });
  }

  Widget _buildNotificationCard(NotificationItem item, bool isReceived) {
    IconData getIcon(String type) {
      switch (type.toLowerCase()) {
        case 'invoice':
          return Icons.receipt;
        case 'payment':
          return Icons.money;
        case 'lead':
          return Icons.person_add;
        case 'reminder':
          return Icons.notifications;
        default:
          return Icons.notifications;
      }
    }

    Color getIconColor(String type) {
      switch (type.toLowerCase()) {
        case 'invoice':
          return Colors.purple.shade100;
        case 'payment':
          return Colors.green.shade100;
        case 'lead':
          return Colors.green.shade100;
        case 'reminder':
          return Colors.blue.shade100;
        default:
          return Colors.blue.shade100;
      }
    }

    Color getIconIconColor(String type) {
      switch (type.toLowerCase()) {
        case 'invoice':
          return Colors.purple;
        case 'payment':
          return Colors.green.shade700;
        case 'lead':
          return Colors.green.shade700;
        case 'reminder':
          return Colors.blue.shade700;
        default:
          return Colors.blue.shade700;
      }
    }

    return GestureDetector(
      onTap: () => controller.handleNotificationTap(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: getIconColor(item.additionalData),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(item.additionalData),
              color: getIconIconColor(item.additionalData),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          isReceived
                              ? 'From: ${item.fromStaffName}'
                              : 'To: ${item.toStaffName}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.formatDate(item.date),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (item.isRead == 0) ...[
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    ));
  }
}

class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(size.width / 2, -15, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
