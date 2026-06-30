import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'expenses_controller.dart';

class ExpensesView extends GetView<ExpensesController> {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expense', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Manage your Expenses', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/pdf_icon.png', width: 20, height: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('assets/images/excel_icon.png', width: 20, height: 20),
            onPressed: () {},
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
      body: Padding(
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
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF39C12),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildExpenseCard('CA', 'Cab Amount', 'Visit', '21-06-2026', 'Dell Pvt L...', '300.00', 'UPI', 'To visit the company to show t...'),
                  const SizedBox(height: 12),
                  _buildExpenseCard('PE', 'Petrol Charges', 'Visit', '23-06-2026', 'Ambica Pvt...', '2000.00', 'UPI', 'Visiting the Ambica pvtlimited...'),
                  const SizedBox(height: 12),
                  _buildExpenseCard('DE', 'Desiel', 'Visit', '15-06-2026', 'Venkatesh ...', '5000.00', 'Cash', 'checking testing purpose'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(String initials, String title, String subtitle, String date, String person, String amount, String method, String note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    radius: 20,
                    child: Text(initials, style: const TextStyle(color: AppColors.cardDarkBlue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(subtitle, style: const TextStyle(color: AppColors.greyText, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.more_vert, color: AppColors.cardDarkBlue),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(person, style: const TextStyle(fontSize: 13, color: AppColors.greyText)),
                ],
              ),
              Text('₹ $amount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.payment, size: 14, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Text(method, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue)),
              const SizedBox(width: 16),
              const Icon(Icons.note, size: 14, color: AppColors.cardDarkBlue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(note, style: const TextStyle(fontSize: 13, color: AppColors.cardDarkBlue), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
