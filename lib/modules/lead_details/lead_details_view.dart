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
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.notifications, size: 16), SizedBox(width: 4), Text('Follow-Ups')])),
                Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.note_alt_outlined, size: 16), SizedBox(width: 4), Text('Notes')])),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildProfileTab(),
          _buildProposalsTab(),
          _buildFollowUpsTab(),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.profile.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final profile = controller.profile.value;
      if (profile == null) {
        return const Center(child: Text("No Profile Data"));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchLeadDetails,
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
              _buildProfileDetailRow(Icons.person, profile.name, profile.company, true),
              _buildProfileDetailRow(Icons.email, profile.email, '', false),
              _buildProfileDetailRow(Icons.phone, profile.phonenumber, '', false),
              _buildProfileDetailRow(Icons.language, profile.website, '', false),
              
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
                  Expanded(child: _buildProfileDetailRow(Icons.flag, profile.statusName, '', false)),
                  Expanded(child: _buildProfileDetailRow(Icons.share, profile.sourceName, '', false)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildProfileDetailRow(Icons.person, profile.assignedTo, '', false)),
                  Expanded(child: _buildProfileDetailRow(Icons.money, 'Rs ₹${profile.leadValue}', '', false)),
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
              _buildProfileDetailRow(Icons.home, '${profile.address}, ${profile.city}, ${profile.state}, ${profile.zip}', '', false),

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
              _buildProfileDetailRow(Icons.format_align_left, profile.description, '', false),

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
                  Expanded(child: _buildProfileDetailRow(Icons.calendar_today, profile.dateAdded, '', false)),
                  Expanded(child: _buildProfileDetailRow(Icons.person_add, profile.dateAdded, '', false)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildProfileDetailRow(Icons.phone, profile.dateAdded, '', false)),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
        ),
      );
    });
  }

  Widget _buildProfileDetailRow(IconData icon, String text1, String text2, bool isBold) {
    final display1 = text1.trim().isEmpty ? 'N/A' : text1;
    
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
                    display1,
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
    return Obx(() {
      if (controller.isLoading.value && controller.notes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final filteredNotes = controller.notes.where((note) {
        if (controller.notesSearch.value.isEmpty) return true;
        final query = controller.notesSearch.value.toLowerCase();
        return note.description.toLowerCase().contains(query) || note.addedByName.toLowerCase().contains(query);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchLeadDetails,
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
                                    hintText: 'Search notes...',
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
                      children: [
                        SizedBox(height: Get.height * 0.3),
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No Data Found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
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
                  const SizedBox(width: 4),
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

  Widget _buildProposalsTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.proposals.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredProposals = controller.proposals.where((prop) {
        if (controller.proposalsSearch.value.isEmpty) return true;
        final query = controller.proposalsSearch.value.toLowerCase();
        return prop.subject.toLowerCase().contains(query) || prop.proposalTo.toLowerCase().contains(query);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchLeadDetails,
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
                                  onChanged: (value) => controller.proposalsSearch.value = value,
                                  decoration: const InputDecoration(
                                    hintText: 'Search proposals...',
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
                child: filteredProposals.isEmpty 
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: Get.height * 0.3),
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No Data Found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: filteredProposals.map((prop) => 
                            _buildProposalCard(
                              'PRO-${prop.id}', 
                              prop.subject, 
                              prop.proposalTo, 
                              prop.addedByName, 
                              prop.total, 
                              controller.formatDate(prop.date), 
                              prop.status == 1 ? 'Draft' : 'Active'
                            )
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

  Widget _buildProposalCard(String proId, String title, String customer, String user, String price, String date, String status) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4EAE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(proId, style: const TextStyle(color: Color(0xFF2FA998), fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const Icon(Icons.more_vert, size: 20, color: AppColors.textDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Expanded(child: Text(customer, style: const TextStyle(fontSize: 12, color: AppColors.greyText), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.person_add, size: 16, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Text(user, style: const TextStyle(fontSize: 12, color: AppColors.greyText)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.request_quote, size: 16, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cardDarkBlue)),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryOrange),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status, style: const TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold)),
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
        return follow.description.toLowerCase().contains(query) || follow.firstName.toLowerCase().contains(query) || follow.lastName.toLowerCase().contains(query);
      }).toList();

      return RefreshIndicator(
        onRefresh: controller.fetchLeadDetails,
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
                      color: AppColors.cardDarkBlue,
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
                    const Icon(Icons.notifications, color: AppColors.cardDarkBlue, size: 18),
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
}

