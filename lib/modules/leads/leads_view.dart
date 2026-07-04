import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import 'leads_controller.dart';

class LeadsView extends GetView<LeadsController> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: RefreshIndicator(
        onRefresh: controller.fetchLeads,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    icon: Image.asset('assets/images/pdf_icon.png', width: 28, height: 28),
                    onPressed: () {
                      if (controller.filteredLeads.isEmpty) {
                        Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                        return;
                      }
                      
                      List<List<String>> data = [];
                      for (int i = 0; i < controller.filteredLeads.length; i++) {
                        final lead = controller.filteredLeads[i];
                        data.add([
                          (i + 1).toString(),
                          lead.name ?? 'N/A',
                          lead.email ?? 'N/A',
                          lead.phonenumber ?? 'N/A',
                          lead.city ?? 'N/A',
                          lead.sourceName ?? 'N/A',
                        ]);
                      }
                      
                      PdfExportHelper.openTablePdfPreview(
                        title: 'Individual Leads Data',
                        headers: ['S.No', 'Name', 'Email', 'Phone', 'City', 'Source'],
                        data: data,
                        filename: 'leads_data.pdf',
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/excel_icon.png', width: 28, height: 28),
                    onPressed: () {
                      if (controller.filteredLeads.isEmpty) {
                        Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                        return;
                      }
                      
                      List<List<String>> data = [];
                      for (int i = 0; i < controller.filteredLeads.length; i++) {
                        final lead = controller.filteredLeads[i];
                        data.add([
                          (i + 1).toString(),
                          lead.name ?? 'N/A',
                          lead.email ?? 'N/A',
                          lead.phonenumber ?? 'N/A',
                          lead.city ?? 'N/A',
                          lead.sourceName ?? 'N/A',
                        ]);
                      }
                      
                      ExcelExportHelper.shareTableExcel(
                        sheetName: 'Leads Data',
                        headers: ['S.No', 'Name', 'Email', 'Phone', 'City', 'Source'],
                        data: data,
                        filename: 'IndividualLeadsData.xlsx',
                      );
                    },
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 8), // small gap between excel and plus
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Obx(() {
            final total = controller.leads.length;
            final started = controller.leads.where((l) => l.statusName?.toLowerCase() == 'started').length;
            final other = total - started;
            
            return Row(
              children: [
                Expanded(child: _buildStatCard('$started/$total', 'Started', Icons.people, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('$other', 'Other', Icons.forum, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('$total', 'Total', Icons.assignment_turned_in, AppColors.cardDarkBlue)),
              ],
            );
          }),
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
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) => controller.searchLeads(value),
                    decoration: const InputDecoration(
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

          // Dynamic Lead List
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredLeads.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No Data Found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredLeads.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final lead = controller.filteredLeads[index];
                
                String initials = 'NA';
                if (lead.name != null && lead.name!.isNotEmpty) {
                  initials = lead.name!.substring(0, 1).toUpperCase();
                  if (lead.name!.length > 1) {
                    initials += lead.name!.substring(1, 2).toUpperCase();
                  }
                }
                
                bool isFacebook = lead.sourceName?.toLowerCase() == 'facebook';
                bool isGoogle = lead.sourceName?.toLowerCase() == 'google';

                String displayPhone = lead.phonenumber ?? '';
                if (displayPhone.contains(',')) {
                  displayPhone = displayPhone.split(',').first.trim();
                } else if (displayPhone.contains('/')) {
                  displayPhone = displayPhone.split('/').first.trim();
                }

                return _buildLeadCard(
                  id: lead.id ?? 0,
                  initials: initials,
                  name: lead.name ?? 'Unknown',
                  location: lead.city ?? '',
                  org: lead.company ?? '',
                  email: lead.email ?? '',
                  phone: displayPhone,
                  hasFacebook: isFacebook,
                  hasGoogle: isGoogle,
                  sourceName: lead.sourceName ?? '',
                );
              },
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    ),
    ),
    );
  }

  Widget _buildStatCard(String value, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildLeadCard({
    required int id,
    required String initials,
    required String name,
    required String location,
    required String org,
    required String email,
    required bool hasFacebook,
    required bool hasGoogle,
    String phone = '',
    String sourceName = '',
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
                radius: 26,
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
                        const Icon(Icons.location_on, size: 16, color: AppColors.cardDarkBlue),
                        const SizedBox(width: 4),
                        Expanded(child: Text(location.isNotEmpty ? location : 'N/A', style: const TextStyle(fontSize: 14, color: AppColors.cardDarkBlue, fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.cardDarkBlue),
                onSelected: (String result) {
                  int tabIndex = 0;
                  if (result == 'View') tabIndex = 0;
                  if (result == 'Set Follow-Ups') tabIndex = 1;
                  if (result == 'Proposal') tabIndex = 2;
                  if (result == 'Notes') tabIndex = 3;
                  Get.toNamed('/lead-details', arguments: {'initialTabIndex': tabIndex, 'leadId': id});
                },
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'View',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Color(0xFF637381), size: 18),
                        SizedBox(width: 12),
                        Text('View', style: TextStyle(color: Color(0xFF637381), fontSize: 14)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Set Follow-Ups',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(Icons.schedule, color: Color(0xFF637381), size: 18),
                        SizedBox(width: 12),
                        Text('Set Follow-Ups', style: TextStyle(color: Color(0xFF637381), fontSize: 14)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Proposal',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(Icons.edit_document, color: Color(0xFF637381), size: 18),
                        SizedBox(width: 12),
                        Text('Proposal', style: TextStyle(color: Color(0xFF637381), fontSize: 14)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Notes',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(Icons.note_alt_outlined, color: Color(0xFF637381), size: 18),
                        SizedBox(width: 12),
                        Text('Notes', style: TextStyle(color: Color(0xFF637381), fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Details Rows
          Column(
            children: [
              // First Row: Business & Source
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.business, size: 18, color: AppColors.cardDarkBlue),
                        const SizedBox(width: 8),
                        Expanded(child: Text(org.isNotEmpty ? org : 'N/A', style: const TextStyle(fontSize: 14, color: AppColors.textDark))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (hasFacebook || sourceName.toLowerCase() == 'facebook') 
                        const Icon(Icons.facebook, size: 18, color: AppColors.cardDarkBlue)
                      else if (hasGoogle || sourceName.toLowerCase() == 'google')
                        Transform.scale(
                          scale: 1.3,
                          child: Image.asset('assets/images/google_icon.png', width: 18, height: 18, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 18, color: AppColors.cardDarkBlue)),
                        )
                      else
                        const Icon(Icons.share, size: 18, color: AppColors.cardDarkBlue),
                      const SizedBox(width: 8),
                      Text(sourceName.isNotEmpty ? sourceName : (hasFacebook ? 'facebook' : 'N/A'), style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Second Row: Email & Phone
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (email.isNotEmpty && email != 'N/A') _launchUrl('mailto:$email');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.mail, size: 18, color: AppColors.cardDarkBlue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(email.isNotEmpty ? email : 'N/A', style: const TextStyle(fontSize: 14, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (phone.isNotEmpty && phone != 'N/A') _launchUrl('tel:$phone');
                        },
                        child: const Icon(Icons.phone, size: 18, color: AppColors.cardDarkBlue),
                      ),
                      const SizedBox(width: 8),
                      Text(phone.isNotEmpty ? phone : 'N/A', style: const TextStyle(fontSize: 14, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (phone.isNotEmpty && phone != 'N/A')
                        GestureDetector(
                          onTap: () => _launchUrl('https://wa.me/$phone'),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Image.asset('assets/images/whatsapp_icon.png', width: 18, height: 18),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
