import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import 'add_contact_controller.dart';

class AddContactView extends GetView<AddContactController> {
  const AddContactView({super.key});

  Widget _buildTextField({
    required String label,
    required TextEditingController textController,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    RxnString? errorText,
  }) {
    Widget buildField(String? error) {
      return TextField(
        controller: textController,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black54, size: 20) : null,
          errorText: error,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      );
    }

    if (errorText != null) {
      return Obx(() => buildField(errorText.value));
    }
    return buildField(null);
  }

  Widget _buildResponsiveRow(BuildContext context, List<Widget> fields) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return Column(
        children: fields.map((field) => Padding(padding: const EdgeInsets.only(bottom: 16), child: field)).toList(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: fields.asMap().entries.map((entry) {
            int idx = entry.key;
            Widget field = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: idx < fields.length - 1 ? 16 : 0),
                child: field,
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width > 600 ? 600 : Get.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_add, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text(controller.existingContact != null ? 'Update Contact' : 'Add Contact', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildResponsiveRow(context, [
                _buildTextField(label: 'Enter First Name', textController: controller.firstNameController, prefixIcon: Icons.person, errorText: controller.firstNameError),
                _buildTextField(label: 'Enter Last Name', textController: controller.lastNameController, prefixIcon: Icons.person),
              ]),
              _buildResponsiveRow(context, [
                _buildTextField(label: 'Enter Email Address', textController: controller.emailController, prefixIcon: Icons.email, keyboardType: TextInputType.emailAddress),
              ]),
              _buildResponsiveRow(context, [
                _buildTextField(label: 'Enter Phone Number', textController: controller.phoneController, prefixIcon: Icons.phone, keyboardType: TextInputType.phone),
                _buildTextField(label: 'Enter Job Title', textController: controller.titleController, prefixIcon: Icons.work),
              ]),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submitContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardDarkBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
