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
          const SizedBox(height: 50),
          _buildDrawerItem(Icons.home_outlined, 'Dashboard', isSelected: controller.currentIndex.value == 0, tabIndex: 0),
          _buildDrawerItem(Icons.person_outline, 'Leads', isSelected: controller.currentIndex.value == 2, tabIndex: 2),
          _buildDrawerItem(Icons.description_outlined, 'Proposal', route: Routes.PROPOSAL),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.group_outlined, color: Colors.grey[700]),
              title: Text('Customers', style: TextStyle(color: Colors.grey[800])),
              iconColor: Colors.grey[700],
              collapsedIconColor: Colors.grey[700],
              initiallyExpanded: controller.currentIndex.value == 1,
              children: [
                _buildSubItem('Customers List', tabIndex: 1),
                _buildSubItem('Invoices', route: Routes.INVOICES),
                _buildSubItem('Payments', route: Routes.PAYMENTS),
              ],
            ),
          ),

          _buildDrawerItem(Icons.inventory_2_outlined, 'Products', route: Routes.PRODUCTS),
          _buildDrawerItem(Icons.money_outlined, 'Expenses', route: Routes.EXPENSES),
          _buildDrawerItem(Icons.request_quote_outlined, 'Estimates', route: Routes.ESTIMATIONS),
          _buildDrawerItem(Icons.checklist_rtl_outlined, 'Todo', isSelected: controller.currentIndex.value == 3, tabIndex: 3),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.bar_chart_outlined, color: Colors.grey[700]),
              title: Text('Reports', style: TextStyle(color: Colors.grey[800])),
              iconColor: Colors.grey[700],
              collapsedIconColor: Colors.grey[700],
              children: [
                _buildSubItem('Report 1', route: Routes.REPORTS),
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
