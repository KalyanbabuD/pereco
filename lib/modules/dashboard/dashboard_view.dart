import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'dashboard_controller.dart';
import 'widgets/main_drawer.dart';
import '../leads/leads_view.dart';
import '../todo/todo_view.dart';
import '../customers/customers_view.dart';
import '../proposal/proposal_view.dart';
import '../proposal/proposal_controller.dart';
import '../followups/followups_view.dart';
import '../followups/followups_controller.dart';
import '../payments/payments_view.dart';
import '../products/products_view.dart';
import '../expenses/expenses_view.dart';
import '../reports/lead_reports_view.dart';
import '../reports/customer_reports_view.dart';
import '../reports/followup_reports_view.dart';
import '../settings/settings_view.dart';
import '../collections/collections_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color(0xFFF4F6F8),
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F8),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withOpacity(0.2), // Light gray divider line
            height: 1.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.cardDarkBlue),
          onPressed: controller.openDrawer,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 4),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 5.0,
              ), // Nudges the text up slightly
              child: Text(
                'CRM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.cardDarkBlue),
            color: Colors.white,
            onSelected: (String result) {
              if (result == 'Logout') {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                        ),
                        onPressed: () {
                          Get.back(); // Close dialog
                          controller.logout();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        Widget content;
        switch (controller.currentIndex.value) {
          case 0:
            content = _buildHomeContent();
            break;
          case 1:
            content = const CustomersView();
            break;
          case 2:
            content = const LeadsView();
            break;
          case 3:
            content = const TodoView();
            break;
          case 4:
            content = const ProposalView();
            break;
          case 5:
            content = const FollowupsView();
            break;
          case 6:
            content = const PaymentsView();
            break;
          case 7:
            content = const ProductsView();
            break;
          case 8:
            content = const ExpensesView();
            break;
          case 9:
            content = const LeadReportsView();
            break;
          case 10:
            content = const CustomerReportsView();
            break;
          case 11:
            content = const FollowupReportsView();
            break;
          case 12:
            content = const SettingsView();
            break;
          case 13:
            content = const CollectionsView();
            break;
          default:
            content = _buildHomeContent();
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey<int>(controller.currentIndex.value),
            child: content,
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => ClipPath(
          clipper: _BottomNavClipper(),
          child: Container(
            color: AppColors.cardDarkBlue,
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 4,
            ), // Padding to account for the arch
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex.value < 4 ? controller.currentIndex.value : 0,
                selectedItemColor: controller.currentIndex.value < 4 ? Colors.white : Colors.white54,
                unselectedItemColor: Colors.white54,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                onTap: controller.changeTabIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Customers',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.headset_mic),
                    label: 'Leads',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Todo',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchDashboardData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Obx(
              () => Text(
                'Hi ${controller.userName.value.isNotEmpty ? controller.userName.value : "User"}! 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Here's what's happening with your business today.",
              style: TextStyle(fontSize: 14, color: AppColors.greyText),
            ),
            const SizedBox(height: 20),

            // Stats Cards
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = controller.dashboardData.value;
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBlue,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '${data?.totalCustomers ?? 0}',
                            'Customers',
                            Icons.people,
                            AppColors.statCustomers,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            '${data?.totalLeads ?? 0}',
                            'Leads',
                            Icons.headset_mic,
                            AppColors.statLeads,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '${data?.totalTodos ?? 0}',
                            'Todos',
                            Icons.forum,
                            AppColors.statFollowups,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            '${data?.totalReminders ?? 0}',
                            'Reminders',
                            Icons.notifications,
                            AppColors.statReminders,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionIcon('Customers', Icons.people, onTap: () => controller.changeTabIndex(1)),
                _buildActionIcon('Leads', Icons.headset_mic, onTap: () => controller.changeTabIndex(2)),
                _buildActionIcon('Proposal', Icons.edit_document, onTap: () { 
                  controller.changeTabIndex(4); 
                  if (Get.isRegistered<ProposalController>()) {
                    Get.find<ProposalController>().fetchProposals();
                  }
                }),
                _buildActionIcon('Follow-ups', Icons.event_available, onTap: () {
                  controller.changeTabIndex(5);
                  if (Get.isRegistered<FollowupsController>()) {
                    Get.find<FollowupsController>().fetchFollowups();
                  }
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Reports
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionIcon('Customers', Icons.people, onTap: () {}),
                _buildActionIcon('Leads', Icons.phone_in_talk, onTap: () {}),
                _buildActionIcon('Customer Conversion', Icons.how_to_reg, onTap: () {}),
                _buildActionIcon('Follow-ups', Icons.event_available, onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Leads
            Obx(() {
              final recentLeads =
                  controller.dashboardData.value?.recentLeads ?? [];
              final rows = recentLeads.map((lead) {
                return [
                  lead.company?.isNotEmpty == true ? lead.company! : 'N/A',
                  lead.name ?? 'Unknown',
                ];
              }).toList();

              return _buildListCard(
                title: 'Recent Leads',
                headers: ['Organization', 'Name'],
                rows: rows.isEmpty
                    ? [
                        ['No leads', '-'],
                      ]
                    : rows,
                onViewAll: () => controller.changeTabIndex(2),
              );
            }),
            const SizedBox(height: 24),

            // Recent Customers
            Obx(() {
              final recentCustomers =
                  controller.dashboardData.value?.recentCustomers ?? [];
              final rows = recentCustomers.map((customer) {
                String name = customer.company?.isNotEmpty == true
                    ? customer.company!
                    : (customer.contactName ?? 'Unknown');

                // Truncate long names slightly to fit like the web view
                if (name.length > 15) {
                  name = '${name.substring(0, 15)}...';
                }

                return [name, customer.city ?? 'N/A'];
              }).toList();

              return _buildListCard(
                title: 'Recent Customers',
                headers: ['Name', 'City'],
                rows: rows.isEmpty
                    ? [
                        ['No customers', '-'],
                      ]
                    : rows,
                onViewAll: () => controller.changeTabIndex(1),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildStatCard(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardLightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(String title, IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      elevation: 10, // Increased elevation for a stronger shadow
      shadowColor: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 78,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.cardDarkBlue, size: 28),
              const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10, // slightly smaller to fit better
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    bool isFollowup = false,
    VoidCallback? onViewAll,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardDarkBlue,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Row(
                      children: [
                        Text('View All', style: TextStyle(color: Colors.grey)),
                        Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: headers
                      .map(
                        (h) => Expanded(
                          child: Text(
                            h,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                ...rows.map((row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: row.map((cell) {
                        bool isStatus = isFollowup && cell == 'Pending';
                        return Expanded(
                          child: Text(
                            cell,
                            style: TextStyle(
                              color: isStatus
                                  ? Colors.orange
                                  : AppColors.greyText,
                              fontWeight: isStatus
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30); // Start lower on the left edge
    // Curve upwards to the center (highest point), then back down to the right edge
    path.quadraticBezierTo(size.width / 2, -15, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
