import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'expense_details_controller.dart';

class ExpenseDetailsView extends GetView<ExpenseDetailsController> {
  const ExpenseDetailsView({super.key});

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      if (isoString.length >= 10) {
        return isoString.substring(0, 10); // As per screenshot it's "2026-06-21"
      }
      return isoString;
    } catch (e) {
      return isoString;
    }
  }

  Widget _buildSectionHeader(IconData icon, String title, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.cardDarkBlue,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.isEmpty ? 'N/A' : text,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expense = controller.expense;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.cardDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Expense Details',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(Icons.receipt_long, 'Expense Details', Colors.orange),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              
              // Expense Details Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.local_offer, expense.expenseName ?? '')),
                        Expanded(child: _buildInfoRow(Icons.calendar_month, _formatDate(expense.date))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.currency_rupee, expense.amount ?? '0.00')),
                        Expanded(child: _buildInfoRow(Icons.layers, expense.expenseCategoryName ?? '')),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              
              // Customer Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.person, 'Customer Details', Colors.green),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.business, expense.clientName ?? ''),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),

              // Payment Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.credit_card, 'Payment Details', Colors.orange),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInfoRow(Icons.percent, expense.taxName ?? 'N/A')),
                        Expanded(child: _buildInfoRow(Icons.account_balance_wallet, expense.paymentModeName ?? expense.paymentmode ?? 'UPI')),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),

              // Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.description, 'Description', AppColors.cardDarkBlue),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.notes, expense.note ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
