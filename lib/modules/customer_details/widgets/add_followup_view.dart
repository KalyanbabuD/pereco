import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/staff_model.dart';
import 'add_followup_controller.dart';

class AddFollowupView extends GetView<AddFollowupController> {
  const AddFollowupView({super.key});

  Widget _buildTextField({
    required String label,
    required TextEditingController textController,
    IconData? prefixIcon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    RxnString? errorText,
  }) {
    Widget buildField(String? error) {
      return TextField(
        controller: textController,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
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

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.selectedDateTimeRx.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: controller.selectedDateTimeRx.value != null 
          ? TimeOfDay.fromDateTime(controller.selectedDateTimeRx.value!) 
          : TimeOfDay.now(),
      );
      if (time != null) {
        final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        controller.selectedDateTimeRx.value = dt;
        
        // Format as yyyy-MM-dd HH:mm:ss
        final mStr = dt.month.toString().padLeft(2, '0');
        final dStr = dt.day.toString().padLeft(2, '0');
        final hStr = dt.hour.toString().padLeft(2, '0');
        final minStr = dt.minute.toString().padLeft(2, '0');
        final sStr = dt.second.toString().padLeft(2, '0');
        
        controller.dateController.text = '${dt.year}-$mStr-$dStr';
        controller.timeController.text = '$hStr:$minStr:$sStr';
        controller.dateTimeDisplayController.text = '${controller.dateController.text} ${controller.timeController.text}';
        
        controller.dateError.value = null; // Clear error
      }
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_available, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text(controller.existingFollowup != null ? 'Update Follow-Up' : 'Add Follow-Up', 
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
              _buildTextField(
                label: 'Description', 
                textController: controller.descriptionController, 
                prefixIcon: Icons.description, 
                errorText: controller.descriptionError,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Date & Time', 
                      textController: controller.dateTimeDisplayController,
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _pickDateTime(context),
                      errorText: controller.dateError,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() => DropdownButtonFormField2<int>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(Icons.people, color: Colors.black54, size: 20),
                  errorText: controller.staffError.value,
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
                hint: const Text('Select Staff', style: TextStyle(color: Colors.black54, fontSize: 13)),
                items: controller.staffList.map((Staff staff) {
                  return DropdownMenuItem<int>(
                    value: staff.staffid,
                    child: Text(staff.fullName, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                value: controller.selectedStaffId.value,
                onChanged: (value) {
                  controller.selectedStaffId.value = value;
                  controller.staffError.value = null;
                },
                dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              )),
              
              const SizedBox(height: 24),
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
                    onPressed: controller.isLoading.value ? null : controller.submitFollowup,
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
