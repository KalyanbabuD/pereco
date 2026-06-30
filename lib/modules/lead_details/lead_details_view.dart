import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'lead_details_controller.dart';

class LeadDetailsView extends GetView<LeadDetailsController> {
  const LeadDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Lead Details',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Center(
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.lock, color: Colors.white, size: 16),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
            ),
          ),
          Center(
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 16, left: 4),
              decoration: BoxDecoration(
                color: AppColors.cardDarkBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.list, color: Colors.white, size: 16),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
            ),
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
              tabs: [
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.person, size: 16), SizedBox(width: 4), Text('Profile')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.description, size: 16), SizedBox(width: 4), Text('Proposals')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.notifications, size: 16), SizedBox(width: 4), Text('Reminders')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.folder, size: 16), SizedBox(width: 4), Text('Notes')])),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildProfileTab(),
          const Center(child: Text('Proposals (Coming Soon)')),
          const Center(child: Text('Reminders (Coming Soon)')),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.contact_mail, color: AppColors.primaryOrange, size: 20),
                    SizedBox(width: 8),
                    Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Icon(Icons.edit_square, color: AppColors.textDark.withValues(alpha: 0.7), size: 20),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileDetailRow(Icons.person, 'Abdul Shaik', 'perennialcode', true),
            _buildProfileDetailRow(Icons.email, 'shaikabdul2447@gmail.com', '', false),
            _buildProfileDetailRow(Icons.phone, '9346696253', '', false),
            _buildProfileDetailRow(Icons.language, 'http://google.com', '', false),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFEEEEEE)),
            ),

            // Lead Details
            const Row(
              children: [
                Icon(Icons.adjust, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Lead Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildProfileDetailRow(Icons.flag, 'Started', '', false)),
                Expanded(child: _buildProfileDetailRow(Icons.share, 'google', '', false)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildProfileDetailRow(Icons.person, 'venkatesh D', '', false)),
                Expanded(child: _buildProfileDetailRow(Icons.money, 'Rs ₹4,996', '', false)),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFEEEEEE)),
            ),

            // Address
            const Row(
              children: [
                Icon(Icons.location_on, color: AppColors.cardDarkBlue, size: 20),
                SizedBox(width: 8),
                Text('Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProfileDetailRow(Icons.home, 'Hyderabad, Hyderabad, telangana, 500080', '', false),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFEEEEEE)),
            ),

            // Description
            const Row(
              children: [
                Icon(Icons.description, color: AppColors.cardDarkBlue, size: 20),
                SizedBox(width: 8),
                Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProfileDetailRow(Icons.format_align_left, 'Nothing to describe', '', false),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFEEEEEE)),
            ),

            // Timeline
            const Row(
              children: [
                Icon(Icons.history, color: AppColors.cardDarkBlue, size: 20),
                SizedBox(width: 8),
                Text('Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildProfileDetailRow(Icons.calendar_today, '6/17/2026', '', false)),
                Expanded(child: _buildProfileDetailRow(Icons.person_add, '6/17/2026', '', false)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildProfileDetailRow(Icons.phone, '6/17/2026', '', false)),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String text1, String text2, bool isBold) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.greyText),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text1,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (text2.isNotEmpty)
                  Text(
                    text2,
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Padding(
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
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'input search text',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF39C12),
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 20),
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
            child: ListView(
              children: [
                _buildNoteCard('shiva Yadav', '25-06-2026', 'Lead requested a call back to next day'),
                const SizedBox(height: 12),
                _buildNoteCard('venkatesh D', '22-06-2026', 'Lead requested a callback next week.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(String name, String date, String noteText) {
    return Container(
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
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cardDarkBlue)),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_square, size: 16, color: AppColors.textDark),
                  const SizedBox(width: 8),
                  const Icon(Icons.delete, size: 16, color: Colors.red),
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
