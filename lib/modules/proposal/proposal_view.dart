import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import '../../core/widgets/pagination_control.dart';
import 'proposal_controller.dart';
import '../../routes/app_routes.dart';

class ProposalView extends GetView<ProposalController> {
  const ProposalView({super.key});

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
        onRefresh: controller.fetchProposals,
        child: SingleChildScrollView(
          controller: controller.scrollController,
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
                      Text(
                        'Proposals',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cardDarkBlue,
                        ),
                      ),
                      Text(
                        'Manage your Proposals',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.cardDarkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/pdf_icon.png',
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          if (controller.filteredProposals.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          List<List<String>> data = [];
                          for (final proposal in controller.filteredProposals) {
                            data.add([
                              proposal.subject ?? '',
                              proposal.relType ?? '',
                              proposal.addedByName ?? '',
                              proposal.openTill ?? '',
                              proposal.total ?? '0.00',
                              proposal.status == 1 ? 'Draft' : 'Sent',
                            ]);
                          }

                          PdfExportHelper.openTablePdfPreview(
                            title: 'Proposals Data',
                            headers: [
                              'Subject',
                              'Related To',
                              'Assigne',
                              'open_till',
                              'Amount',
                              'Status',
                            ],
                            data: data,
                            filename: 'proposals_data.pdf',
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/excel_icon.png',
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          if (controller.filteredProposals.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          List<List<String>> data = [];
                          for (final proposal in controller.filteredProposals) {
                            data.add([
                              proposal.subject ?? '',
                              proposal.relType ?? '',
                              proposal.addedByName ?? '',
                              '', // Date
                              proposal.openTill ?? '',
                            ]);
                          }

                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Proposals Data',
                            headers: [
                              'Subject',
                              'to',
                              'Assigne',
                              'Date',
                              'Expiry Date',
                            ],
                            data: data,
                            filename: 'ProposalsData.xlsx',
                          );
                        },
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardDarkBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final result = await Get.toNamed(
                              Routes.ADD_PROPOSAL,
                            );
                            if (result == true) {
                              controller.fetchProposals();
                            }
                          },
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
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
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: (value) => controller.searchProposals(value),
                        decoration: const InputDecoration(
                          hintText: 'Search proposals...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          Get.snackbar(
                            'Search',
                            'Search functionality coming soon!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.cardDarkBlue,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Legend
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    _buildLegendItem(Colors.green, 'Customer'),
                    const SizedBox(width: 16),
                    _buildLegendItem(Colors.amber, 'Lead'),
                  ],
                ),
              ),

              // Dynamic Proposal List
              Obx(() {
                if (controller.isLoadingList.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProposals.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const Center(
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
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.paginatedProposals.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final proposal = controller.paginatedProposals[index];
                        return _buildProposalCard(proposal);
                      },
                    ),
                    Obx(
                      () => PaginationControl(
                        currentPage: controller.currentPage.value,
                        totalPages: controller.totalPages,
                        onPageChanged: controller.goToPage,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }

  Widget _buildProposalCard(dynamic proposal) {
    final bool isCustomer = proposal.relType == 'customer';
    final dotColor = isCustomer ? Colors.green : Colors.amber;

    return InkWell(
      onTap: () {
        if (proposal.id != null) {
          controller.fetchProposalDetails(proposal.id!);
          Get.toNamed(Routes.PROPOSAL_DETAILS);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PRO-${proposal.id}',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          proposal.subject ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.cardDarkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 0),
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: AppColors.cardDarkBlue,
                  ),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  onSelected: (String result) {
                    if (result == 'view') {
                      controller.fetchProposalDetails(proposal.id!);
                      Get.toNamed(Routes.PROPOSAL_DETAILS);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 16,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text('View', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 14,
                        color: AppColors.cardDarkBlue,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          proposal.proposalTo ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 14,
                        color: AppColors.cardDarkBlue,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          proposal.addedByName ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom Row (Total, Date, Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 14,
                      color: AppColors.cardDarkBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      proposal.total ?? '0.00',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDark,
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
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(proposal.openTill),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Draft',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
