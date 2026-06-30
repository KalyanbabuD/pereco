import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'invoices_controller.dart';

class InvoicesView extends GetView<InvoicesController> {
  const InvoicesView({super.key});

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
            Text('Invoice', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Manage your Invoices', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 12)),
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
                  _buildInvoiceCard(
                    id: 'INV-32212',
                    company: 'Anu enggnering works',
                    amount: '23980.00',
                    person: 'shiva Yadav',
                    issueDate: '25 June 2026',
                    dueDate: '25 July 2026',
                    status: 'Draft',
                    statusColor: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildInvoiceCard(
                    id: 'INV-1001',
                    company: 'Ambica Pvt Ltd',
                    amount: '59590.00',
                    person: 'shiva Yadav',
                    issueDate: '22 June 2026',
                    dueDate: '22 July 2026',
                    status: 'Draft',
                    statusColor: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildInvoiceCard(
                    id: 'INV-1024',
                    company: 'N/A',
                    amount: '1050.00',
                    person: 'N/A',
                    issueDate: '22 June 2026',
                    dueDate: '22 July 2026',
                    status: 'Draft',
                    statusColor: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildInvoiceCard(
                    id: 'INV-2',
                    company: '2',
                    amount: '1000000.00',
                    person: 'venkatesh D',
                    issueDate: '06 November 2024',
                    dueDate: '14 November 2024',
                    status: 'Inactive',
                    statusColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard({
    required String id,
    required String company,
    required String amount,
    required String person,
    required String issueDate,
    required String dueDate,
    required String status,
    required Color statusColor,
  }) {
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.cardDarkBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.description, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, color: AppColors.cardDarkBlue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.business, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 8),
                  Text(company, style: const TextStyle(fontSize: 13, color: AppColors.greyText)),
                ],
              ),
              Text('₹ $amount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(person, style: const TextStyle(fontSize: 13, color: AppColors.greyText)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.cardDarkBlue),
                  const SizedBox(width: 4),
                  Text(issueDate, style: const TextStyle(fontSize: 13, color: AppColors.greyText)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(dueDate, style: const TextStyle(fontSize: 13, color: Colors.redAccent)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
