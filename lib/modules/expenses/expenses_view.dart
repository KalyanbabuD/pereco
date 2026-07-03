import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import 'expenses_controller.dart';

class ExpensesView extends GetView<ExpensesController> {
  const ExpensesView({super.key});

  String _getInitials(String name) {
    if (name.isEmpty) return 'NA';
    List<String> parts = name.split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      if (isoString.length >= 10) {
        final parts = isoString.substring(0, 10).split('-');
        if (parts.length == 3) {
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
      return isoString;
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F6F8),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Manage your Expenses',
              style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/pdf_icon.png',
              width: 28,
              height: 28,
            ),
            onPressed: () {
              if (controller.filteredExpenses.isEmpty) {
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
              for (final expense in controller.filteredExpenses) {
                data.add([
                  expense.expenseName ?? '',
                  _formatDate(expense.date),
                  expense.expenseCategoryName ?? '',
                  expense.amount ?? '',
                  expense.clientName ?? '',
                  expense.projectId?.toString() ?? '',
                  expense.paymentmode?.toString() ?? '',
                ]);
              }

              PdfExportHelper.openTablePdfPreview(
                title: 'Expenses Data',
                headers: [
                  'Name',
                  'Date',
                  'Category',
                  'Amount',
                  'Customer',
                  'Project',
                  'Payment Type',
                ],
                data: data,
                filename: 'expenses_data.pdf',
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
              if (controller.filteredExpenses.isEmpty) {
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
              for (final expense in controller.filteredExpenses) {
                data.add([
                  expense.expenseName ?? '',
                  _formatDate(expense.date),
                  expense.expenseCategoryName ?? '',
                  expense.amount ?? '',
                  expense.clientName ?? '',
                  expense.projectId?.toString() ?? '',
                  expense.paymentmode?.toString() ?? '',
                ]);
              }

              ExcelExportHelper.shareTableExcel(
                sheetName: 'Expenses Data',
                headers: [
                  'Name',
                  'Date',
                  'Category',
                  'Amount',
                  'Customer',
                  'Project',
                  'Payment Type',
                ],
                data: data,
                filename: 'ExpensesData.xlsx',
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, left: 4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.cardDarkBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              padding: EdgeInsets.zero,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchExpenses();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchExpenses,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF39C12), // Orange search button
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Expenses Grid
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredExpenses.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text('No expenses found')),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 800) {
                          crossAxisCount = 2;
                        }

                        final double itemWidth =
                            (constraints.maxWidth - (crossAxisCount - 1) * 16) /
                            crossAxisCount;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(
                            controller.filteredExpenses.length,
                            (index) {
                              final expense =
                                  controller.filteredExpenses[index];

                              return SizedBox(
                                width: itemWidth,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.blue
                                                .withOpacity(0.1),
                                            child: Text(
                                              _getInitials(
                                                expense.expenseName ?? '',
                                              ),
                                              style: const TextStyle(
                                                color: AppColors.cardDarkBlue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expense.expenseName ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.cardDarkBlue,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  expense.expenseCategoryName ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: AppColors.cardDarkBlue,
                                              size: 20,
                                            ),
                                            color: Colors.white,
                                            onSelected: (value) {
                                              if (value == 'view') {
                                                Get.toNamed('/expense-details', arguments: expense);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'view',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.visibility, size: 20, color: AppColors.cardDarkBlue),
                                                    SizedBox(width: 12),
                                                    Text('View'),
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
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                size: 14,
                                                color: AppColors.cardDarkBlue,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDate(expense.date),
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  size: 14,
                                                  color: AppColors.cardDarkBlue,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    expense.clientName ?? 'N/A',
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 12,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.currency_rupee,
                                                size: 14,
                                                color: AppColors.cardDarkBlue,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                expense.amount ?? '0.00',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.credit_card,
                                            size: 14,
                                            color: AppColors.cardDarkBlue,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            expense.paymentModeName ??
                                                expense.paymentmode ??
                                                'UPI',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.description,
                                            size: 14,
                                            color: AppColors.cardDarkBlue,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              (expense.note ?? '').replaceAll(
                                                '\n',
                                                ' ',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
