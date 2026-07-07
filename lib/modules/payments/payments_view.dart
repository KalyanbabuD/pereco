import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'payments_controller.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  String _formatCurrency(String? amountStr) {
    if (amountStr == null || amountStr.isEmpty) return '₹0';
    try {
      double amount = double.parse(amountStr);
      return '₹${amount.toStringAsFixed(0)}';
    } catch (e) {
      return '₹$amountStr';
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
                      Text(
                        'Payments',
                        style: TextStyle(
                          color: AppColors.cardDarkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'Manage your Payments',
                        style: TextStyle(
                          color: AppColors.cardDarkBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                          if (controller.filteredPayments.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          List<List<String>>
                          data = controller.filteredPayments.map((p) {
                            return [
                              'PAY-${p.id ?? ''}',
                              '${p.invoicePrefix ?? ''}${p.invoiceNumber ?? ''}',
                              p.paymentModeName ?? '',
                              p.transactionid ?? '',
                              p.clientName ?? '',
                              p.amount ?? '0.00',
                              _formatDate(p.date),
                            ];
                          }).toList();
                          PdfExportHelper.openTablePdfPreview(
                            title: 'Payments Data',
                            headers: [
                              'Payment',
                              'Invoice',
                              'Payment Mode',
                              'Transaction Id',
                              'Customer',
                              'Amount',
                              'Date',
                            ],
                            data: data,
                            filename: 'payments_data.pdf',
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
                          if (controller.filteredPayments.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          List<List<String>>
                          data = controller.filteredPayments.map((p) {
                            return [
                              'PAY-${p.id ?? ''}',
                              '${p.invoicePrefix ?? ''}${p.invoiceNumber ?? ''}',
                              p.paymentModeName ?? '',
                              p.transactionid ?? '',
                              p.clientName ?? '',
                              p.amount ?? '0.00',
                              _formatDate(p.date),
                            ];
                          }).toList();
                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Payments Data',
                            headers: [
                              'Payment',
                              'Invoice',
                              'Payment Mode',
                              'Transaction Id',
                              'Customer',
                              'Amount',
                              'Date',
                            ],
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
                          onTap: () => _showAddPaymentBottomSheet(context),
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
              const SizedBox(height: 16),

              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (value) =>
                              controller.searchPayments(value),
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
                    Container(
                      width: 48,
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
                          size: 24,
                        ),
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
                  if (controller.isListLoading.value) {
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
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchPayments,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: controller.filteredPayments.map((payment) {
                          // Calculate amounts
                          double invoiceAmt =
                              double.tryParse(payment.invoiceAmount ?? '0') ??
                              0;
                          double paidAmt =
                              double.tryParse(payment.amount ?? '0') ?? 0;
                          double dueAmt = invoiceAmt - paidAmt;
                          if (dueAmt < 0) dueAmt = 0;

                          double paidPercent = invoiceAmt > 0
                              ? (paidAmt / invoiceAmt).clamp(0.0, 1.0)
                              : 0.0;
                          double duePercent = invoiceAmt > 0
                              ? (dueAmt / invoiceAmt).clamp(0.0, 1.0)
                              : 0.0;

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
                                // Top Row (Info)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Section
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AppColors.cardDarkBlue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'P',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
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
                                                  'PAY-${payment.id ?? ''}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.cardDarkBlue,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${payment.invoicePrefix ?? ''}${payment.invoiceNumber ?? ''}',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                      size: 12,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        payment.clientName ??
                                                            '-',
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 11,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Middle Section
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _formatCurrency(payment.amount),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: Colors.black87,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  _formatDate(payment.date),
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.credit_card,
                                                color: Colors.black87,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  payment.paymentModeName ??
                                                      payment.paymentmethod ??
                                                      '-',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Popup Menu
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: AppColors.cardDarkBlue,
                                        size: 20,
                                      ),
                                      color: Colors.white,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onSelected: (value) {
                                        if (value == 'Make As Payment') {
                                          // TODO
                                        } else if (value == 'Reminder') {
                                          // TODO
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(
                                              value: 'Make As Payment',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.credit_card,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Make As Payment',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem<String>(
                                              value: 'Reminder',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.notifications_none,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Reminder',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 16),

                                // Bottom Section (Progress Bars)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Invoice',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(
                                            payment.invoiceAmount,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Paid',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(payment.amount),
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearProgressIndicator(
                                      value: paidPercent,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.green,
                                          ),
                                      minHeight: 6,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Due',
                                          style: TextStyle(
                                            color: Color(0xFFE67E22),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(dueAmt.toString()),
                                          style: const TextStyle(
                                            color: Color(0xFFE67E22),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearProgressIndicator(
                                      value: duePercent,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Color(0xFFE67E22),
                                          ),
                                      minHeight: 6,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
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

  void _showAddPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add payments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cardDarkBlue,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fill out the form to add a new payment',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Select Invoice
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              isExpanded: true,
                              hint: const Text(
                                'Select Invoice',
                                style: TextStyle(color: Colors.grey),
                              ),
                              value: controller.selectedInvoiceId.value,
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 300,
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController:
                                    controller.invoiceSearchController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller:
                                        controller.invoiceSearchController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                      hintText: 'Search invoice...',
                                      hintStyle: const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  final text = (item.child as Text).data ?? '';
                                  return text.toLowerCase().contains(
                                    searchValue.toLowerCase(),
                                  );
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  controller.invoiceSearchController.clear();
                                }
                              },
                              items: controller.invoices.map((inv) {
                                return DropdownMenuItem<int>(
                                  value: inv.id,
                                  child: Text(
                                    '${inv.prefix ?? ''}${inv.number ?? ''}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.selectedInvoiceId.value = val;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount
                      TextFormField(
                        controller: controller.amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.currency_rupee, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Payment Mode
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              hint: const Text(
                                'Payment Mode',
                                style: TextStyle(color: Colors.grey),
                              ),
                              value: controller.selectedPaymentModeId.value,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              items: controller.paymentModes.map((mode) {
                                return DropdownMenuItem<int>(
                                  value: mode.id,
                                  child: Text(mode.name),
                                );
                              }).toList(),
                              onChanged: (val) {
                                controller.selectedPaymentModeId.value = val;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Payment Method
                      TextFormField(
                        controller: controller.paymentMethodController,
                        decoration: InputDecoration(
                          hintText: 'Payment Method',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.account_balance_wallet, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date
                      TextFormField(
                        controller: controller.dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Date',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            controller.dateController.text =
                                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Transaction ID
                      TextFormField(
                        controller: controller.transactionIdController,
                        decoration: InputDecoration(
                          hintText: 'Transaction ID',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.receipt_long, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Note
                      TextFormField(
                        controller: controller.noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.description, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardDarkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.addPayment(),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
