import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'settings_controller.dart';
import 'org_settings_view.dart';
import 'preferences_view.dart';
import '../products/products_view.dart';
import '../products/products_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controllers are registered
    Get.put(SettingsController());
    Get.put(ProductsController());

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            //color: Colors.g,
            width: double.infinity,
            child: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
              labelColor: AppColors.cardDarkBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.cardDarkBlue,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2, size: 18),
                      SizedBox(width: 8),
                      Text('Products'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.domain, size: 18),
                      SizedBox(width: 8),
                      Text('Org Settings'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune, size: 18),
                      SizedBox(width: 8),
                      Text('Preferences'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [ProductsView(), OrgSettingsView(), PreferencesView()],
            ),
          ),
        ],
      ),
    );
  }
}
