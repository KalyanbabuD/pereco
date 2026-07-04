import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'add_expense_controller.dart';
import '../../data/models/expense_dropdown_models.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../customers/add_customer_view.dart' as import_add_customer;
import '../customers/add_customer_controller.dart' as import_add_customer;
import 'expenses_controller.dart';

class AddExpenseView extends GetView<AddExpenseController> {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.expense != null ? 'Edit Expense' : 'Add Expense', style: const TextStyle(color: AppColors.cardDarkBlue, fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('Fill out the form to ${controller.expense != null ? 'update the' : 'add a new'} expense', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.cardDarkBlue),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Form Fields
                    _buildTextField(
                      controller: controller.expenseNameController,
                      hint: 'Expense Name *',
                      prefixIcon: Icons.request_quote_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildDatePicker(context),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: controller.amountController,
                      hint: 'Amount *',
                      prefixIcon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Two column rows for dropdowns on larger screens, wrap on mobile
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 600;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildDropdown(
                                  hint: 'Category *',
                                  items: controller.categories,
                                  selectedValue: controller.selectedCategory,
                                  prefixIcon: Icons.layers_outlined,
                                  searchController: controller.categorySearchController,
                                )),
                                if (!isMobile) const SizedBox(width: 16),
                                if (!isMobile) Expanded(child: _buildDropdown(
                                  hint: 'Customer',
                                  items: controller.customers,
                                  selectedValue: controller.selectedCustomer,
                                  prefixIcon: Icons.business_outlined,
                                  searchController: controller.customerSearchController,
                                )),
                              ],
                            ),
                            if (isMobile) const SizedBox(height: 16),
                            if (isMobile) _buildDropdown(
                              hint: 'Customer',
                              items: controller.customers,
                              selectedValue: controller.selectedCustomer,
                              prefixIcon: Icons.business_outlined,
                              searchController: controller.customerSearchController,
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(child: _buildDropdown(
                                  hint: 'Currency',
                                  items: controller.currencies,
                                  selectedValue: controller.selectedCurrency,
                                  prefixIcon: Icons.money_outlined,
                                  searchController: controller.currencySearchController,
                                )),
                                if (!isMobile) const SizedBox(width: 16),
                                if (!isMobile) Expanded(child: _buildDropdown(
                                  hint: 'Tax',
                                  items: controller.taxes,
                                  selectedValue: controller.selectedTax,
                                  prefixIcon: Icons.percent_outlined,
                                  searchController: controller.taxSearchController,
                                )),
                              ],
                            ),
                            if (isMobile) const SizedBox(height: 16),
                            if (isMobile) _buildDropdown(
                              hint: 'Tax',
                              items: controller.taxes,
                              selectedValue: controller.selectedTax,
                              prefixIcon: Icons.percent_outlined,
                              searchController: controller.taxSearchController,
                            ),
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(child: _buildDropdown(
                                  hint: 'Payment Mode',
                                  items: controller.paymentModes,
                                  selectedValue: controller.selectedPaymentMode,
                                  prefixIcon: Icons.credit_card_outlined,
                                  searchController: controller.paymentModeSearchController,
                                )),
                                if (!isMobile) const SizedBox(width: 16),
                                if (!isMobile) const Spacer(), // Empty space on the right for symmetry
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      controller: controller.descriptionController,
                      hint: 'Description',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardDarkBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: controller.submitExpense,
                          child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black54, size: 20) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate.value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != controller.selectedDate.value) {
          controller.selectedDate.value = picked;
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.selectedDate.value != null 
                    ? '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedDate.value!.year}' 
                    : 'dd-mm-yyyy',
                style: TextStyle(
                  color: controller.selectedDate.value != null ? Colors.black : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<DropdownItem> items,
    required Rxn<int> selectedValue,
    required IconData prefixIcon,
    required TextEditingController searchController,
    Widget? suffixAction,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton2<int>(
                isExpanded: true,
                hint: Text(hint, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                value: selectedValue.value,
                iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54)),
                onChanged: (val) {
                  selectedValue.value = val;
                },
                items: items.map((DropdownItem item) {
                  return DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        hintText: 'Search...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    final textWidget = item.child as Text;
                    return textWidget.data!.toLowerCase().contains(searchValue.toLowerCase());
                  },
                ),
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    searchController.clear();
                  }
                },
              )),
            ),
          ),
          if (suffixAction != null) ...[
            const SizedBox(width: 8),
            suffixAction,
          ],
        ],
      ),
    );
  }
}
