import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'payments_controller.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';

class PaymentsView extends GetView<PaymentsController> {
  const PaymentsView({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: RefreshIndicator(
        onRefresh: controller.fetchPayments,
        child: Padding(
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
                      Text('Invoice Payment', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 22)),
                      Text('Manage your Invoice Payments', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/pdf_icon.png', width: 28, height: 28),
                        onPressed: () {
                          if (controller.filteredPayments.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = controller.filteredPayments.map((p) {
                            return [
                              'PAY-${p.id ?? ''}',
                              '${p.invoicePrefix ?? ''}${p.invoiceNumber ?? ''}',
                              p.paymentModeName ?? '',
                              p.transactionid ?? '',
                              '', // Customer is empty in screenshot
                              p.amount ?? '0.00',
                              _formatDate(p.date),
                            ];
                          }).toList();
                          
                          PdfExportHelper.openTablePdfPreview(
                            title: 'Payments Data',
                            headers: ['Payment', 'Invoice', 'Payment Mode', 'Transaction Id', 'Customer', 'Amount', 'Date'],
                            data: data,
                            filename: 'payments_data.pdf',
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/excel_icon.png', width: 28, height: 28),
                        onPressed: () {
                          if (controller.filteredPayments.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = controller.filteredPayments.map((p) {
                            return [
                              'PAY-${p.id ?? ''}',
                              '${p.invoicePrefix ?? ''}${p.invoiceNumber ?? ''}',
                              p.paymentModeName ?? '',
                              p.transactionid ?? '',
                              '', // Customer is empty in screenshot
                              p.amount ?? '0.00',
                              _formatDate(p.date),
                            ];
                          }).toList();
                          
                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Payments Data',
                            headers: ['Payment', 'Invoice', 'Payment Mode', 'Transaction Id', 'Customer', 'Amount', 'Date'],
                            data: data,
                            filename: 'PaymentsData.xlsx',
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
                            onChanged: (value) => controller.searchPayments(value),
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

              // Payments List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredPayments.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.fetchPayments,
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
                    onRefresh: controller.fetchPayments,
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 140, // Enough height for 3 rows
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                    itemCount: controller.filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = controller.filteredPayments[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Top Row: Circle Icon + ID + 3 dots
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cardDarkBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.receipt_long, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PAY-${payment.id ?? ''}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue, fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'INV-${payment.invoiceid ?? ''}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: AppColors.cardDarkBlue, size: 20),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onSelected: (value) {
                                    if (value == 'View') {
                                      Get.toNamed(
                                        '/payment-details', 
                                        arguments: {'paymentId': payment.id}
                                      );
                                    } else if (value == 'Edit') {
                                      // Edit logic here
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'View', 
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility, color: Colors.grey, size: 20),
                                          SizedBox(width: 8),
                                          Text('View'),
                                        ],
                                      )
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Edit', 
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.grey, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Middle Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.credit_card, color: AppColors.cardDarkBlue, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      payment.paymentModeName ?? '-',
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '₹ ${payment.amount ?? '0.00'}',
                                      style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.fingerprint, color: AppColors.cardDarkBlue, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      payment.transactionid ?? '-',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Bottom Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit, color: AppColors.cardDarkBlue, size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          payment.note ?? '-',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: AppColors.cardDarkBlue, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatDate(payment.date),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
