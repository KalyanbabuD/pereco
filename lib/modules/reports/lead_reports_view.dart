import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'widgets/report_date_picker.dart';

class LeadReportsView extends StatelessWidget {
  const LeadReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and action buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lead Reports', style: TextStyle(color: AppColors.cardDarkBlue, fontWeight: FontWeight.bold, fontSize: 20)),
                Text('Manage your lead Reports', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                      ),
                      child: const Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    // PDF / Excel icons
                    IconButton(
                      icon: Image.asset('assets/images/pdf_icon.png', width: 28, height: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Image.asset('assets/images/excel_icon.png', width: 28, height: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Filters Row
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: ReportDatePicker(label: 'From Date')),
                    const SizedBox(width: 16),
                    const Expanded(child: ReportDatePicker(label: 'To Date')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _buildDropdown('Report Period')),
                    const SizedBox(width: 16),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Data Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 34),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: const BoxDecoration(
                                  color: AppColors.cardDarkBlue,
                                ),
                                child: Row(
                                  children: [
                                    _buildHeaderCell('#', width: 40, isHeader: true),
                                    _buildHeaderCell('Name', width: 150, isHeader: true),
                                    _buildHeaderCell('Title', width: 120, isHeader: true),
                                    _buildHeaderCell('Company', width: 150, isHeader: true),
                                    _buildHeaderCell('City', width: 100, isHeader: true),
                                    _buildHeaderCell('State', width: 100, isHeader: true),
                                    _buildHeaderCell('Email', width: 180, isHeader: true),
                                    _buildHeaderCell('Mobile', width: 120, isHeader: true),
                                    _buildHeaderCell('Added', width: 100, isHeader: true),
                                    _buildHeaderCell('Last Contact', width: 120, isHeader: true),
                                  ],
                                ),
                              ),
                              // Table Body (Empty for now)
                              const Expanded(
                                child: Center(child: Text('No data available')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Pagination
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        children: [
                          _buildPaginationButton('Previous', disabled: true),
                          const SizedBox(width: 8),
                          _buildPaginationButton('Next', disabled: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Choose', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String title, {required double width, bool isHeader = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isHeader ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildPaginationButton(String text, {bool disabled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: disabled ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 13),
      ),
    );
  }
}
