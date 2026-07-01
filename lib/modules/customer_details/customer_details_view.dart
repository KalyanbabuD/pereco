import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import 'customer_details_controller.dart';
import '../../data/models/customer_model.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      Get.snackbar('Error', 'Could not launch $urlString', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title: const Text('Customer Details', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
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
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              tabs: const [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person, size: 16), SizedBox(width: 4), Text('Profile')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.contacts, size: 16), SizedBox(width: 4), Text('Contacts')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.schedule, size: 16), SizedBox(width: 4), Text('Follow-Ups')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.note_alt_outlined, size: 16), SizedBox(width: 4), Text('Notes')])),
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
    );
  }

  Widget _buildProfileTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.customerDetails.value == null) {
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
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information
                const Row(
                  children: [
                    Icon(Icons.business, color: AppColors.primaryOrange, size: 20),
                    SizedBox(width: 8),
                    Text('Customer Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProfileDetailRow(Icons.business, profile.company, '', true),
                Row(
                  children: [
                    Expanded(child: _buildProfileDetailRow(Icons.phone, profile.phonenumber, '', false)),
                    Expanded(child: _buildProfileDetailRow(Icons.language, profile.website, '', false)),
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
                    Text('Address Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildProfileDetailRow(Icons.location_city, profile.city, '', false)),
                    Expanded(child: _buildProfileDetailRow(Icons.map, profile.state, '', false)),
                  ],
                ),
                _buildProfileDetailRow(Icons.markunread_mailbox, profile.zip, '', false),
                _buildProfileDetailRow(Icons.home, profile.address, '', false),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),

                // Billing Address
                const Row(
                  children: [
                    Icon(Icons.receipt_long, color: AppColors.primaryOrange, size: 20),
                    SizedBox(width: 8),
                    Text('Billing Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProfileDetailRow(Icons.home, profile.billingStreet, '', false),
                Row(
                  children: [
                    Expanded(child: _buildProfileDetailRow(Icons.location_city, profile.billingCity, '', false)),
                    Expanded(child: _buildProfileDetailRow(Icons.map, profile.billingState, '', false)),
                  ],
                ),
                _buildProfileDetailRow(Icons.markunread_mailbox, profile.billingZip, '', false),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Color(0xFFEEEEEE)),
                ),
                
                // Shipping Address
                const Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildProfileDetailRow(Icons.home, profile.shippingStreet, '', false),
                Row(
                  children: [
                    Expanded(child: _buildProfileDetailRow(Icons.location_city, profile.shippingCity, '', false)),
                    Expanded(child: _buildProfileDetailRow(Icons.map, profile.shippingState, '', false)),
                  ],
                ),
                _buildProfileDetailRow(Icons.markunread_mailbox, profile.shippingZip, '', false),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileDetailRow(IconData icon, String? text1, String? text2, bool isBold) {
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
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal
                  )
                ),
                if (text2 != null && text2.isNotEmpty)
                  Text(text2, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.customerDetails.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final profile = controller.customerDetails.value;

      bool matchesSearch(Customer? p) {
        if (p == null) return false;
        if (controller.contactsSearch.value.isEmpty) return true;
        final q = controller.contactsSearch.value.toLowerCase();
        return (p.contactName?.toLowerCase().contains(q) ?? false) ||
               (p.email?.toLowerCase().contains(q) ?? false) ||
               (p.contactPhone?.toLowerCase().contains(q) ?? false);
      }

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
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) => controller.contactsSearch.value = value,
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
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: (!matchesSearch(profile)) 
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 100), Center(child: Text("No contacts found"))],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            if (profile != null && profile.contactName != null && profile.contactName!.isNotEmpty)
                              _buildContactCard(
                                profile.contactName!, 
                                profile.title ?? 'N/A', 
                                profile.email ?? 'N/A', 
                                profile.contactPhone ?? 'N/A'
                              )
                          ],
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

  Widget _buildContactCard(String name, String title, String email, String phone) {
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
                  const Icon(Icons.person, size: 18, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.cardDarkBlue)),
                ],
              ),
              const Icon(Icons.edit_square, size: 18, color: AppColors.primaryOrange),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Expanded(child: Text(email, style: const TextStyle(fontSize: 13, color: AppColors.textDark), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              const Icon(Icons.phone, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(phone, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
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
        return follow.description.toLowerCase().contains(query) || follow.firstName.toLowerCase().contains(query) || follow.lastName.toLowerCase().contains(query);
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
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) => controller.followUpsSearch.value = value,
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
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredFollowUps.isEmpty 
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 100), Center(child: Text("No follow ups found"))],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: filteredFollowUps.map((follow) => 
                            _buildFollowUpCard(follow.description, '${follow.firstName} ${follow.lastName}', controller.formatDate(follow.date))
                          ).toList(),
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

  Widget _buildFollowUpCard(String title, String user, String date) {
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
                    const Icon(Icons.notifications, color: AppColors.primaryOrange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),
              ),
              const Icon(Icons.edit_square, size: 18, color: AppColors.textDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.greyText),
              const SizedBox(width: 4),
              Text(user, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today, size: 14, color: AppColors.greyText),
              const SizedBox(width: 4),
              Text(date, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
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
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Center(
                                child: TextField(
                                  onChanged: (value) => controller.notesSearch.value = value,
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
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset('assets/images/pdf_icon.png', width: 24, height: 24),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/excel_icon.png', width: 24, height: 24),
                  const SizedBox(width: 8),
                  Container(
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
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredNotes.isEmpty 
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 100), Center(child: Text("No notes found"))],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: filteredNotes.map((note) => 
                            _buildNoteCard(note.addedByName, controller.formatDate(note.dateAdded), note.description)
                          ).toList(),
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

  Widget _buildNoteCard(String name, String date, String noteText) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.cardDarkBlue)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cardDarkBlue)),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_square, size: 16, color: AppColors.cardDarkBlue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.description, size: 16, color: AppColors.greyText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  noteText,
                  style: const TextStyle(color: AppColors.greyText, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
