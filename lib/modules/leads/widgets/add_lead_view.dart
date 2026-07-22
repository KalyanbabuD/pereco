import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../core/app_colors.dart';
import 'add_lead_controller.dart';
import '../../../../data/models/lead_source_model.dart';
import '../../../../data/models/staff_model.dart';

import '../../../../data/models/lead_status_model.dart';

class AddLeadView extends StatelessWidget {
  const AddLeadView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is put here or by whoever calls this bottom sheet
    final controller = Get.put(AddLeadController());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.existingLead != null ? 'Edit Lead' : 'Add Lead',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue),
                  ),
                  const Text(
                    'Fill out the form to add a new lead',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.cardDarkBlue),
                onPressed: () => Get.back(),
              )
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: Obx(() {
              if (controller.isLoading.value && controller.sources.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField('Enter Name *', controller.nameController, Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField('Enter Mobile Number *', controller.mobileController, Icons.phone),
                    const SizedBox(height: 12),
                    _buildTextField('Enter Email', controller.emailController, Icons.email),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Enter Company', controller.companyController, Icons.business),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField2<int>(
                            isExpanded: true,
                            dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                            decoration: _dropdownDecoration(),
                            hint: const Text('Select Source *', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            value: controller.selectedSourceId.value,
                            items: controller.sources.map((LeadSource s) {
                              return DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(s.name ?? 'Unknown', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) => controller.selectedSourceId.value = val,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField2<int>(
                            isExpanded: true,
                            dropdownStyleData: const DropdownStyleData(maxHeight: 250, decoration: BoxDecoration(color: Colors.white)),
                            decoration: _dropdownDecoration(),
                            hint: const Text('Select Status *', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            value: controller.selectedStatusId.value,
                            items: controller.statuses.map((LeadStatus s) {
                              return DropdownMenuItem<int>(
                                value: s.id,
                                child: Text(s.name ?? 'Unknown', style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) => controller.selectedStatusId.value = val,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('City', controller.cityController, Icons.location_city),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Enter Address *', controller.addressController, Icons.location_on),
                    const SizedBox(height: 12),
                    _buildTextField('Enter Description', controller.descriptionController, null, maxLines: 4),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.submitLead,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cardDarkBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: controller.isLoading.value 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData? prefixIcon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 18) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
