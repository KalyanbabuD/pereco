import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';

class LeadsView extends StatelessWidget {
  const LeadsView({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Could not open app for $url');
      debugPrint('Could not launch $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leads', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue)),
                  Text('Manage your Leads', style: TextStyle(fontSize: 14, color: AppColors.cardDarkBlue, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/pdf_icon.png', width: 20, height: 20),
                    onPressed: () {
                      Get.snackbar('Export', 'PDF export coming soon!', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/excel_icon.png', width: 20, height: 20),
                    onPressed: () {
                      Get.snackbar('Export', 'Excel export coming soon!', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                    },
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(left: 8), // small gap between excel and plus
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              Expanded(child: _buildStatCard('8/10', 'Active', Icons.people, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('8', 'Followups', Icons.forum, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('2', 'Tasks', Icons.assignment_turned_in, AppColors.cardDarkBlue)),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF39C12), // Lighter golden orange instead of primaryOrange
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      Get.snackbar('Search', 'Search functionality coming soon!', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lead List
          _buildLeadCard(
            initials: 'AB',
            name: 'Abdul Shaik',
            location: 'Hyderabad',
            org: 'perennialcode',
            email: 'shaikabdul2447@gmail.com',
          ),
          const SizedBox(height: 16),
          _buildLeadCard(
            initials: 'JO',
            name: 'John Doe',
            location: 'Hyderabad',
            org: 'ABC Pvt Ltd',
            email: 'john.doe@example.com',
            phone: '9876543210',
          ),
          const SizedBox(height: 16),
          _buildLeadCard(
            initials: 'VE',
            name: 'Venky Nama',
            location: 'hyderabad',
            org: 'N/A',
            email: 'customercare@perennialcod...',
            phone: '01234567890',
            hasFacebook: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLeadCard({
    required String initials,
    required String name,
    required String location,
    required String org,
    required String email,
    String phone = 'N/A',
    bool hasFacebook = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Top Row (Avatar, Name, Menu)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE3EBF7),
                child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.cardDarkBlue),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(fontSize: 13, color: AppColors.cardDarkBlue, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.primaryOrange),
                onSelected: (String result) {
                  if (result == 'View') {
                    Get.toNamed('/lead-details');
                  }
                },
                color: Colors.white,
                surfaceTintColor: Colors.white,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'View',
                    child: ListTile(
                      leading: Icon(Icons.remove_red_eye, size: 20),
                      title: Text('View'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Set Reminder',
                    child: ListTile(
                      leading: Icon(Icons.alarm, size: 20),
                      title: Text('Set Reminder'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Proposal',
                    child: ListTile(
                      leading: Icon(Icons.description, size: 20),
                      title: Text('Proposal'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Notes',
                    child: ListTile(
                      leading: Icon(Icons.note, size: 20),
                      title: Text('Notes'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Details Rows
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business, size: 14, color: AppColors.cardDarkBlue),
                        const SizedBox(width: 8),
                        Expanded(child: Text(org, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _launchUrl('mailto:$email'),
                      child: Row(
                        children: [
                          const Icon(Icons.mail, size: 14, color: AppColors.cardDarkBlue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(email, style: const TextStyle(fontSize: 12, color: AppColors.textDark), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right Column
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(hasFacebook ? Icons.facebook : Icons.share, size: 14, color: AppColors.cardDarkBlue),
                        const SizedBox(width: 8),
                        Text(hasFacebook ? 'facebook' : 'N/A', style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (phone != 'N/A') {
                              _launchUrl('tel:$phone');
                            }
                          },
                          child: const Icon(Icons.phone, size: 14, color: AppColors.cardDarkBlue),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(phone, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
                        if (phone != 'N/A')
                          GestureDetector(
                            onTap: () => _launchUrl('https://wa.me/$phone'),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Image.asset('assets/images/whatsapp_icon.png', width: 20, height: 20),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
