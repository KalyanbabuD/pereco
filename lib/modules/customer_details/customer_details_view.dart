import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import 'customer_details_controller.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/lead_details_models.dart';
import 'widgets/add_contact_controller.dart' as add_contact_c;
import 'widgets/add_contact_view.dart' as add_contact_v;
import 'widgets/add_followup_controller.dart' as add_followup_c;
import 'widgets/add_followup_view.dart' as add_followup_v;
import 'widgets/add_note_controller.dart' as add_note_c;
import 'widgets/add_note_view.dart' as add_note_v;
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import '../dashboard/dashboard_controller.dart';
import '../../routes/app_routes.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      Get.snackbar(
        'Error',
        'Could not launch $urlString',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.cardDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Customer Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelColor: AppColors.primaryOrange,
              unselectedLabelColor: AppColors.greyText,
              indicatorColor: AppColors.primaryOrange,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 16),
                      SizedBox(width: 4),
                      Text('Profile'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contacts, size: 16),
                      SizedBox(width: 4),
                      Text('Contacts'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, size: 16),
                      SizedBox(width: 4),
                      Text('Follow-Ups'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined, size: 16),
                      SizedBox(width: 4),
                      Text('Notes'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildProfileTab(),
          _buildContactsTab(),
          _buildFollowUpsTab(),
          _buildNotesTab(),
        ],
      ),
      bottomNavigationBar: GetBuilder<DashboardController>(
        init: Get.isRegistered<DashboardController>()
            ? Get.find<DashboardController>()
            : Get.put(DashboardController()),
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
                    currentIndex: dashController.currentIndex.value < 4
                        ? dashController.currentIndex.value
                        : 0,
                    selectedItemColor: dashController.currentIndex.value < 4
                        ? Colors.white
                        : Colors.white54,
                    unselectedItemColor: Colors.white54,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    onTap: (index) {
                      dashController.changeTabIndex(index);
                      Get.until(
                        (route) => route.settings.name == Routes.DASHBOARD,
                      );
                    },
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
          );
        },
      ),
    );
  }

  Widget _buildProfileTab() {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.customerDetails.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final profile = controller.customerDetails.value;
      if (profile == null) {
        return const Center(child: Text('Failed to load profile.'));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchCustomerDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information
                const Row(
                  children: [
                    Icon(
                      Icons.business,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Customer Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProfileDetailRow(
                  Icons.business,
                  profile.company,
                  '',
                  true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.phone,
                        profile.phonenumber,
                        '',
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.language,
                        profile.website,
                        '',
                        false,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),

                // Address Information
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Address Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.location_city,
                        profile.city,
                        '',
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.map,
                        profile.state,
                        '',
                        false,
                      ),
                    ),
                  ],
                ),
                _buildProfileDetailRow(
                  Icons.markunread_mailbox,
                  profile.zip,
                  '',
                  false,
                ),
                _buildProfileDetailRow(Icons.home, profile.address, '', false),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),

                // Billing Address
                const Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: AppColors.primaryOrange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Billing Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProfileDetailRow(
                  Icons.home,
                  profile.billingStreet,
                  '',
                  false,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.location_city,
                        profile.billingCity,
                        '',
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.map,
                        profile.billingState,
                        '',
                        false,
                      ),
                    ),
                  ],
                ),
                _buildProfileDetailRow(
                  Icons.markunread_mailbox,
                  profile.billingZip,
                  '',
                  false,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),

                // Shipping Address
                const Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Shipping Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProfileDetailRow(
                  Icons.home,
                  profile.shippingStreet,
                  '',
                  false,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.location_city,
                        profile.shippingCity,
                        '',
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildProfileDetailRow(
                        Icons.map,
                        profile.shippingState,
                        '',
                        false,
                      ),
                    ),
                  ],
                ),
                _buildProfileDetailRow(
                  Icons.markunread_mailbox,
                  profile.shippingZip,
                  '',
                  false,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileDetailRow(
    IconData icon,
    String? text1,
    String? text2,
    bool isBold,
  ) {
    final display1 = (text1 == null || text1.trim().isEmpty) ? 'N/A' : text1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.greyText),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  display1,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (text2 != null && text2.isNotEmpty)
                  Text(
                    text2,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greyText,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.contacts.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredContacts = controller.contacts.where((c) {
        if (controller.contactsSearch.value.isEmpty) return true;
        final q = controller.contactsSearch.value.toLowerCase();
        return (c.firstname?.toLowerCase().contains(q) ?? false) ||
            (c.lastname?.toLowerCase().contains(q) ?? false) ||
            (c.email?.toLowerCase().contains(q) ?? false) ||
            (c.phonenumber?.toLowerCase().contains(q) ?? false);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchCustomerDetails,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) =>
                                      controller.contactsSearch.value = value,
                                  decoration: const InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF39C12),
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        GetBuilder<add_contact_c.AddContactController>(
                          init: add_contact_c.AddContactController()
                            ..customerId = controller.customerId,
                          builder: (_) => const add_contact_v.AddContactView(),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredContacts.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: Get.height * 0.3),
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Contacts Found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: filteredContacts
                                .map((c) => _buildContactCard(c))
                                .toList(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContactCard(Contact contact) {
    String name = '${contact.firstname ?? ''} ${contact.lastname ?? ''}'.trim();
    if (name.isEmpty) name = 'N/A';
    String title = (contact.title != null && contact.title!.isNotEmpty)
        ? contact.title!
        : 'N/A';
    String email = (contact.email != null && contact.email!.isNotEmpty)
        ? contact.email!
        : 'N/A';
    String phone =
        (contact.phonenumber != null && contact.phonenumber!.isNotEmpty)
        ? contact.phonenumber!
        : 'N/A';

    return Container(
      width: Get.width > 700 ? 320 : Get.width - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                    color: AppColors.cardDarkBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.cardDarkBlue,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    GetBuilder<add_contact_c.AddContactController>(
                      init: add_contact_c.AddContactController()
                        ..customerId = controller.customerId
                        ..existingContact = contact,
                      builder: (_) => const add_contact_v.AddContactView(),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: const Icon(
                  Icons.edit_square,
                  size: 18,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppColors.greyText),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.phone, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                phone,
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpsTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.followUps.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredFollowUps = controller.followUps.where((follow) {
        if (controller.followUpsSearch.value.isEmpty) return true;
        final query = controller.followUpsSearch.value.toLowerCase();
        return follow.description.toLowerCase().contains(query) ||
            follow.firstName.toLowerCase().contains(query) ||
            follow.lastName.toLowerCase().contains(query);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchCustomerDetails,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) =>
                                      controller.followUpsSearch.value = value,
                                  decoration: const InputDecoration(
                                    hintText: 'Search reminders...',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF39C12),
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        GetBuilder<add_followup_c.AddFollowupController>(
                          init: add_followup_c.AddFollowupController()
                            ..customerId = controller.customerId,
                          builder: (_) =>
                              const add_followup_v.AddFollowupView(),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredFollowUps.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: Get.height * 0.3),
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Data Found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: filteredFollowUps
                                .map((follow) => _buildFollowUpCard(follow))
                                .toList(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFollowUpCard(FollowUp followUp) {
    return Container(
      width: Get.width > 700 ? 300 : Get.width - 32,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notifications,
                      color: AppColors.cardDarkBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        followUp.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    GetBuilder<add_followup_c.AddFollowupController>(
                      init: add_followup_c.AddFollowupController()
                        ..customerId = controller.customerId
                        ..relType = 'Customer'
                        ..existingFollowup = followUp,
                      builder: (_) => const add_followup_v.AddFollowupView(),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: const Icon(
                  Icons.edit_square,
                  size: 18,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.greyText),
              const SizedBox(width: 4),
              Text(
                '${followUp.firstName} ${followUp.lastName}',
                style: const TextStyle(fontSize: 12, color: AppColors.greyText),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.greyText,
              ),
              const SizedBox(width: 4),
              Text(
                controller.formatDate(followUp.date),
                style: const TextStyle(fontSize: 12, color: AppColors.greyText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.notes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredNotes = controller.notes.where((note) {
        if (controller.notesSearch.value.isEmpty) return true;
        final query = controller.notesSearch.value.toLowerCase();
        return note.description.toLowerCase().contains(query);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchCustomerDetails,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) =>
                                      controller.notesSearch.value = value,
                                  decoration: const InputDecoration(
                                    hintText: 'input search text',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF39C12),
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (filteredNotes.isEmpty) {
                        Get.snackbar(
                          'Export',
                          'No notes to export',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      PdfExportHelper.openTablePdfPreview(
                        title: 'Customer Notes',
                        filename: 'customer_notes.pdf',
                        headers: ['Description', 'Added By', 'Date Added'],
                        data: filteredNotes
                            .map(
                              (note) => [
                                note.description,
                                note.addedByName,
                                controller.formatDate(note.dateAdded),
                              ],
                            )
                            .toList(),
                      );
                    },
                    child: Image.asset(
                      'assets/images/pdf_icon.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (filteredNotes.isEmpty) {
                        Get.snackbar(
                          'Export',
                          'No notes to export',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      ExcelExportHelper.shareTableExcel(
                        sheetName: 'Notes',
                        filename: 'customer_notes.xlsx',
                        headers: ['Description', 'Added By', 'Date Added'],
                        data: filteredNotes
                            .map(
                              (note) => [
                                note.description,
                                note.addedByName,
                                controller.formatDate(note.dateAdded),
                              ],
                            )
                            .toList(),
                      );
                    },
                    child: Image.asset(
                      'assets/images/excel_icon.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        GetBuilder<add_note_c.AddNoteController>(
                          init: add_note_c.AddNoteController()
                            ..customerId = controller.customerId,
                          builder: (_) => const add_note_v.AddNoteView(),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.cardDarkBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredNotes.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: Get.height * 0.3),
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No Data Found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: filteredNotes
                                .map((note) => _buildNoteCard(note))
                                .toList(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      width: Get.width > 700 ? 320 : Get.width - 32,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.cardDarkBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          note.addedByName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.cardDarkBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.cardDarkBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.formatDate(note.dateAdded),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.cardDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description,
                      size: 16,
                      color: AppColors.greyText,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        note.description,
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    GetBuilder<add_note_c.AddNoteController>(
                      init: add_note_c.AddNoteController()
                        ..customerId = controller.customerId
                        ..relType = 'Customer'
                        ..existingNote = note,
                      builder: (_) => const add_note_v.AddNoteView(),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: const Icon(
                  Icons.edit_square,
                  size: 16,
                  color: AppColors.cardDarkBlue,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    title: 'Delete Note',
                    middleText: 'Are you sure you want to delete this note?',
                    textConfirm: 'Delete',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back();
                      controller.deleteNote(note.id);
                    },
                  );
                },
                child: const Icon(Icons.delete, size: 18, color: Colors.red),
              ),
            ],
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
