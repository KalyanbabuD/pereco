import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../core/app_colors.dart';
import 'add_proposal_controller.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/lead_model.dart';
import '../../../data/models/staff_model.dart';
import '../../../data/models/product_model.dart';

class AddProposalView extends GetView<AddProposalController> {
  const AddProposalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.cardDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Add Proposal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Proposal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue)),
              const SizedBox(height: 16),
              _buildTopDropdowns(),
              const SizedBox(height: 24),
              _buildProposalDetailsSection(context),
              const SizedBox(height: 24),
              _buildProductsSection(),
              const SizedBox(height: 24),
              _buildSummarySection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopDropdowns() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                  decoration: _dropdownDecoration(),
                  value: controller.relType.value,
                  items: ['Customer', 'Lead'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (val) {
                    if (val != null) controller.onRelTypeChanged(val);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField2<int>(
                  isExpanded: true,
                  dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                  decoration: _dropdownDecoration(),
                  value: controller.statusId.value,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Draft', style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 2, child: Text('Sent', style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 3, child: Text('Expired', style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 4, child: Text('Declined', style: TextStyle(fontSize: 14))),
                    DropdownMenuItem(value: 5, child: Text('Accepted', style: TextStyle(fontSize: 14))),
                  ],
                  onChanged: (val) {
                    if (val != null) controller.statusId.value = val;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.relType.value == 'Customer') {
              return DropdownButtonFormField2<int>(
                isExpanded: true,
                dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                decoration: _dropdownDecoration(),
                hint: const Text('Select Customer', style: TextStyle(fontSize: 14, color: Colors.grey)),
                value: controller.selectedCustomerId.value,
                items: controller.customers.map((Customer c) {
                  return DropdownMenuItem<int>(
                    value: c.customerId,
                    child: Text(c.company ?? c.firstname ?? 'Unknown', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: controller.onCustomerSelected,
                dropdownSearchData: DropdownSearchData(
                  searchController: TextEditingController(),
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    final c = controller.customers.firstWhere((c) => c.customerId == item.value);
                    final name = (c.company ?? c.firstname ?? '').toLowerCase();
                    return name.contains(searchValue.toLowerCase());
                  },
                ),
              );
            } else {
              return DropdownButtonFormField2<int>(
                isExpanded: true,
                dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                decoration: _dropdownDecoration(),
                hint: const Text('Select Lead', style: TextStyle(fontSize: 14, color: Colors.grey)),
                value: controller.selectedLeadId.value,
                items: controller.leads.map((Lead l) {
                  return DropdownMenuItem<int>(
                    value: l.id,
                    child: Text(l.name ?? l.company ?? 'Unknown', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: controller.onLeadSelected,
                dropdownSearchData: DropdownSearchData(
                  searchController: TextEditingController(),
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    final l = controller.leads.firstWhere((l) => l.id == item.value);
                    final name = (l.name ?? l.company ?? '').toLowerCase();
                    return name.contains(searchValue.toLowerCase());
                  },
                ),
              );
            }
          }),
          const SizedBox(height: 16),
          DropdownButtonFormField2<int>(
            isExpanded: true,
            dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
            decoration: _dropdownDecoration(),
            hint: const Text('Select Staff', style: TextStyle(fontSize: 14, color: Colors.grey)),
            value: controller.selectedStaffId.value,
            items: controller.staffList.map((Staff s) {
              return DropdownMenuItem<int>(
                value: s.staffid,
                child: Text(s.fullName, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) => controller.selectedStaffId.value = val,
            dropdownSearchData: DropdownSearchData(
              searchController: TextEditingController(),
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Search staff...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                final s = controller.staffList.firstWhere((s) => s.staffid == item.value);
                final name = s.fullName.toLowerCase();
                return name.contains(searchValue.toLowerCase());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalDetailsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, color: AppColors.primaryOrange, size: 20),
              const SizedBox(width: 8),
              const Text('Proposal Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('Enter Subject', controller.subjectController),
          const SizedBox(height: 16),
          _buildTextField(
            'Date', 
            controller.dateController,
            suffixIcon: Icons.calendar_today,
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(),
                firstDate: DateTime(2000), 
                lastDate: DateTime(2100)
              );
              if (picked != null) {
                final dateStr = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                controller.dateController.text = dateStr;
              }
            }
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('Email', controller.emailController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('Phone', controller.phoneController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('Address', controller.addressController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('City', controller.cityController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('State', controller.stateController)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('Zip Code', controller.zipController)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Proposal Content', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.greyText)),
          const SizedBox(height: 8),
          _buildTextField('Proposal Content', controller.contentController, maxLines: 5),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: AppColors.primaryOrange, size: 20),
              const SizedBox(width: 8),
              const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField2<Product>(
            isExpanded: true,
            dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
            decoration: _dropdownDecoration(),
            hint: const Text('Select Product', style: TextStyle(fontSize: 14, color: Colors.grey)),
            value: controller.selectedProduct.value,
            items: controller.productsList.map((Product p) {
              return DropdownMenuItem<Product>(
                value: p,
                child: Text(p.description ?? 'Unknown', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (Product? p) => controller.addProduct(p),
            dropdownSearchData: DropdownSearchData(
              searchController: TextEditingController(),
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    hintText: 'Search product...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                final p = item.value as Product;
                final name = (p.description ?? '').toLowerCase();
                return name.contains(searchValue.toLowerCase());
              },
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
            children: controller.proposalItems.map((item) => _buildProductItemCard(item)).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(ProposalItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(item.product.description ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => controller.removeProduct(item),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity', style: TextStyle(fontSize: 12, color: Colors.black87)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.qty.value > 1) {
                          item.qty.value--;
                          controller.proposalItems.refresh(); // trigger UI update for totals
                        }
                      },
                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Icon(Icons.remove, size: 16)),
                    ),
                    Obx(() => Text('${item.qty.value}', style: const TextStyle(fontSize: 14))),
                    InkWell(
                      onTap: () {
                        item.qty.value++;
                        controller.proposalItems.refresh(); // trigger UI update for totals
                      },
                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Icon(Icons.add, size: 16)),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          _buildReceiptRow('Rate', '₹ ${item.rate.toStringAsFixed(0)}'),
          _buildReceiptRow('Tax', '${item.taxPercent.toStringAsFixed(0)}%'),
          _buildReceiptRow('Subtotal', '₹ ${item.subtotal.toStringAsFixed(2)}'),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('₹ ${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        children: [
          _buildReceiptRow('Subtotal', '₹ ${controller.totalSubtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildReceiptRow('Tax', '₹ ${controller.totalTax.toStringAsFixed(2)}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('₹ ${controller.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: controller.submitProposal,
              icon: const Icon(Icons.save, color: Colors.white, size: 18),
              label: const Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardDarkBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {IconData? suffixIcon, bool readOnly = false, VoidCallback? onTap, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey, size: 20) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryOrange),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryOrange),
      ),
    );
  }
}
