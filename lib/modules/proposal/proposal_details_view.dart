import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'proposal_controller.dart';
import '../../core/app_colors.dart';

class ProposalDetailsView extends GetView<ProposalController> {
  const ProposalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposal Details'),
        backgroundColor: AppColors.cardDarkBlue,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = controller.proposalDetails.value?.proposal;
        final items = controller.proposalDetails.value?.itemDetails ?? [];

        if (details == null) {
          return const Center(child: Text('Proposal not found'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchProposalDetails(details.id!),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(details),
                const SizedBox(height: 16),
                _buildDescriptionSection(details),
                const SizedBox(height: 16),
                _buildCustomerDetailsSection(details),
                const SizedBox(height: 16),
                _buildItemsList(items),
                const SizedBox(height: 16),
                _buildSummarySection(details),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection(dynamic details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.subject ?? 'No Subject',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        details.proposalTo ?? 'Unknown', 
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Open', style: TextStyle(color: Colors.blue, fontSize: 12)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(details.addedByName ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(dynamic details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Proposal Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(details.content ?? '', style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsSection(dynamic details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.contact_mail, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Customer Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Name', details.proposalTo),
                    const SizedBox(height: 12),
                    _buildDetailItem('Phone', details.phone),
                    const SizedBox(height: 12),
                    _buildDetailItem('State', details.state),
                    const SizedBox(height: 12),
                    _buildDetailItem('Address', details.address),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Email', details.email),
                    const SizedBox(height: 12),
                    _buildDetailItem('City', details.city),
                    const SizedBox(height: 12),
                    _buildDetailItem('ZIP', details.zip),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value ?? '-', style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ],
    );
  }

  Widget _buildItemsList(List<dynamic> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.description ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${item.rate}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Per ${item.unit}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (item.longDescription != null && item.longDescription!.isNotEmpty)
                Text(
                  item.longDescription!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemStat('Qty', item.qty),
                  _buildItemStat('Unit', item.unit),
                  _buildItemStat('Amount', '₹${item.qty != null && item.rate != null ? (double.parse(item.qty!) * double.parse(item.rate!)).toStringAsFixed(0) : "0"}'),
                ],
              ),
              const Divider(height: 32),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemStat(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildSummarySection(dynamic details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Proposal Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '₹${details.subtotal ?? "0.00"}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax', '₹${details.totalTax ?? "0.00"}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Adjustment', '₹${details.adjustment ?? "0.00"}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('₹${details.total ?? "0.00"}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
