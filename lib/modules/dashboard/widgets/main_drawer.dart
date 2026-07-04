import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../dashboard_controller.dart';
import '../../../routes/app_routes.dart';

class MainDrawer extends GetView<DashboardController> {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 90, bottom: 45, left: 16, right: 16),
            color: AppColors.cardDarkBlue, // Dark blue background
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    'CRM',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),
          _buildDrawerItem(Icons.home, 'Dashboard', isSelected: controller.currentIndex.value == 0, tabIndex: 0),
          _buildDrawerItem(Icons.person_add_alt_1, 'Leads', isSelected: controller.currentIndex.value == 2, tabIndex: 2),
          _buildDrawerItem(Icons.assignment, 'Proposal', isSelected: controller.currentIndex.value == 4, tabIndex: 4),
          _buildDrawerItem(Icons.person, 'Customers', isSelected: controller.currentIndex.value == 1, tabIndex: 1),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.credit_card, color: Colors.grey[700]),
              title: Text('Payments', style: TextStyle(color: Colors.grey[800])),
              iconColor: Colors.grey[700],
              collapsedIconColor: Colors.grey[700],
              children: [
                _buildSubItem('Collections', route: null),
                _buildSubItem('Payments', tabIndex: 6),
              ],
            ),
          ),

          _buildDrawerItem(Icons.inventory_2, 'Products', tabIndex: 7),
          _buildDrawerItem(Icons.payments, 'Expenses', tabIndex: 8),
          _buildDrawerItem(Icons.list_alt, 'Todo', isSelected: controller.currentIndex.value == 3, tabIndex: 3),
          _buildDrawerItem(Icons.phone, 'Follow Up', isSelected: controller.currentIndex.value == 5, tabIndex: 5),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
              title: Text('Reports', style: TextStyle(color: Colors.grey[800])),
              iconColor: Colors.grey[700],
              collapsedIconColor: Colors.grey[700],
              children: [
                _buildSubItem('Leads', tabIndex: 9),
                _buildSubItem('Customers', tabIndex: 10),
                _buildSubItem('Follow-Ups', tabIndex: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false, String? route, int? tabIndex}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryOrange : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryOrange : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Get.back(); // close drawer
        if (tabIndex != null) {
          controller.changeTabIndex(tabIndex);
        } else if (route != null) {
          Get.toNamed(route);
        }
      },
    );
  }

  Widget _buildSubItem(String title, {String? route, int? tabIndex}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72, right: 16),
      title: Row(
        children: [
          const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        ],
      ),
      onTap: () {
        Get.back();
        if (tabIndex != null) {
          controller.changeTabIndex(tabIndex);
        } else if (route != null) {
          Get.toNamed(route);
        }
      },
    );
  }
}
