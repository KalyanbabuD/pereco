import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'payment_details_controller.dart';

class PaymentDetailsView extends GetView<PaymentDetailsController> {
  const PaymentDetailsView({super.key});

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
      appBar: AppBar(
        title: const Text('View Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.cardDarkBlue,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.paymentDetails.value;
        if (details == null) {
          return const Center(child: Text('Failed to load payment details'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPaymentDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Use LayoutBuilder for simple responsive (Row on wide, Column on mobile)
                LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFormFields(details)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildReceiptSection(details)),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormFields(details),
                      const SizedBox(height: 24),
                      _buildReceiptSection(details),
                    ],
                  );
                }
              }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFormFields(details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReadOnlyField('Amount', details.amount ?? ''),
          const SizedBox(height: 16),
          _buildReadOnlyField('Payment Mode', details.paymentsModeName ?? ''),
          const SizedBox(height: 16),
          _buildReadOnlyField('Date', _formatDate(details.paymentdate)),
          const SizedBox(height: 16),
          _buildReadOnlyField('Transaction ID', details.transactionid ?? ''),
          const SizedBox(height: 16),
          _buildReadOnlyField('Description', details.paymentnote ?? '', maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(color: Colors.black87),
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptSection(details) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Receipt',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue),
            ),
          ),
          const SizedBox(height: 24),
          
          // First Table: Receipt Key-Values
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
              top: BorderSide(color: Colors.grey.shade300, width: 1),
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            children: [
              _buildTableRow('Payment Date:', _formatDate(details.paymentdate)),
              _buildTableRow('Payment Mode:', details.paymentsModeName ?? ''),
              _buildTableRow('Transaction Id:', details.transactionid ?? ''),
            ],
          ),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue)),
              const SizedBox(width: 12),
              Text('₹ ${details.amount ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Payment For:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cardDarkBlue),
          ),
          const SizedBox(height: 16),
          
          // Second Table: Payment For
          Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: AppColors.cardDarkBlue),
                      children: [
                        _buildTableHeader('Invoice No'),
                        _buildTableHeader('Invoice Date'),
                        _buildTableHeader('Invoice Amount'),
                        _buildTableHeader('Payment Amount'),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell('${details.prefix ?? ''}${details.invoiceNumber ?? ''}'),
                        _buildTableCell(_formatDate(details.invoiceDate)),
                        _buildTableCell('₹ ${details.invoiceTotal ?? '0.00'}'),
                        _buildTableCell('₹ ${details.amount ?? '0.00'}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }
}
