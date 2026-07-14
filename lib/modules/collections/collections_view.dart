import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/widgets/pagination_control.dart';
import 'collections_controller.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(String? amountStr) {
    if (amountStr == null || amountStr.isEmpty) return '0.00';
    try {
      final double amount = double.parse(amountStr);
      final parts = amount.toStringAsFixed(2).split('.');
      final formattedInteger = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
      return '$formattedInteger.${parts[1]}';
    } catch (e) {
      return amountStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CollectionsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Credits', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 22)),
                      Text('Manage your Credits here', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/pdf_icon.png', width: 28, height: 28),
                        onPressed: () {
                          if (controller.filteredCreditNotes.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = controller.filteredCreditNotes.map((c) {
                            return [
                              '${c.prefix ?? ''}${c.number ?? ''}',
                              c.clientName ?? '',
                              c.total ?? '0.00',
                              _formatDate(c.date),
                              c.addedByName ?? '',
                              c.clientnote ?? '',
                            ];
                          }).toList();
                          
                          PdfExportHelper.openTablePdfPreview(
                            title: 'Credit Notes Data',
                            headers: ['ID', 'Client Name', 'Amount', 'Date', 'Added By', 'Note'],
                            data: data,
                            filename: 'credit_notes_data.pdf',
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/excel_icon.png', width: 28, height: 28),
                        onPressed: () {
                          if (controller.filteredCreditNotes.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = controller.filteredCreditNotes.map((c) {
                            return [
                              '${c.prefix ?? ''}${c.number ?? ''}',
                              c.clientName ?? '',
                              c.total ?? '0.00',
                              _formatDate(c.date),
                              c.addedByName ?? '',
                              c.clientnote ?? '',
                            ];
                          }).toList();
                          
                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Credit Notes Data',
                            headers: ['ID', 'Client Name', 'Amount', 'Date', 'Added By', 'Note'],
                            data: data,
                            filename: 'CreditNotesData.xlsx',
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
                          onTap: () => _showAddCreditNoteBottomSheet(context, controller),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Center(
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (value) => controller.searchCreditNotes(value),
                            decoration: const InputDecoration(
                              hintText: 'Search...',
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
                      width: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF39C12),
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.search, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Credit Notes List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.creditNotes.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredCreditNotes.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.fetchCreditNotes,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
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
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchCreditNotes,
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.paginatedCreditNotes.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final cn = controller.paginatedCreditNotes[index];
                              return _buildCreditNoteCard(context, cn, controller);
                            },
                          ),
                          Obx(() => PaginationControl(
                                currentPage: controller.currentPage.value,
                                totalPages: controller.totalPages,
                                onPageChanged: controller.goToPage,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildCreditNoteCard(BuildContext context, creditNote, CollectionsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          // Top Row: Circle Icon + ID + Status + Amount + 3 dots
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.cardDarkBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${creditNote.prefix ?? ''}${creditNote.number ?? ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            creditNote.status == 1 ? 'Open' : 'Closed',
                            style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '₹ ${_formatAmount(creditNote.total)}',
                style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Obx(() {
                final isVisible = controller.visibleNotes.contains(creditNote.id ?? 0);
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.cardDarkBlue, size: 24),
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'toggle_note') {
                      controller.toggleNoteVisibility(creditNote.id ?? 0);
                    } else if (value == 'edit') {
                      controller.openEditCreditNote(creditNote);
                      _showAddCreditNoteBottomSheet(context, controller);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'toggle_note',
                        child: Row(
                          children: [
                            Icon(isVisible ? Icons.visibility_off : Icons.visibility, size: 20, color: AppColors.cardDarkBlue),
                            const SizedBox(width: 12),
                            Text(isVisible ? 'Hide Note' : 'Show Note'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20, color: AppColors.cardDarkBlue),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    ];
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.cardDarkBlue, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        creditNote.clientName ?? '-',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.cardDarkBlue, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(creditNote.date),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.person_add, color: AppColors.cardDarkBlue, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        creditNote.addedByName ?? '-',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            final isVisible = controller.visibleNotes.contains(creditNote.id ?? 0);
            if (!isVisible || (creditNote.clientnote == null || creditNote.clientnote!.isEmpty)) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2, color: AppColors.cardDarkBlue, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      creditNote.clientnote!,
                      style: const TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showAddCreditNoteBottomSheet(BuildContext context, CollectionsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Credit Note',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Customer Dropdown
              const Text('Customer', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton2<int>(
                    isExpanded: true,
                    hint: const Text('Select Customer', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    value: controller.selectedCustomerId.value,
                    iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54)),
                    onChanged: (val) {
                      controller.selectedCustomerId.value = val;
                    },
                    items: controller.customers.map((c) {
                      String name = c.company?.isNotEmpty == true ? c.company! : (c.contactName ?? 'Unknown');
                      return DropdownMenuItem<int>(
                        value: c.customerId,
                        child: Text(name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: controller.customerSearchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                        child: TextFormField(
                          controller: controller.customerSearchController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            hintText: 'Search...',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final textWidget = item.child as Text;
                        return textWidget.data!.toLowerCase().contains(searchValue.toLowerCase());
                      },
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        controller.customerSearchController.clear();
                      }
                    },
                  )),
                ),
              ),
              const SizedBox(height: 16),

              // Date
              const Text('Date', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    final formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                    controller.dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Total Amount
              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Note
              const Text('Note', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter note',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isEditing = controller.editingCreditNoteId.value != null;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEditing ? Colors.grey : AppColors.cardDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: (controller.isLoading.value || isEditing) ? null : () => controller.addCreditNote(),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            isEditing ? 'Save (Disabled for Edit)' : 'Save',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}
