import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/utils/date_utils.dart';
import 'followups_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../data/models/reminder_model.dart';
import '../../data/models/staff_model.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/lead_model.dart';

class FollowupsView extends GetView<FollowupsController> {
  const FollowupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Follow Ups', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 22)),
                    Text('Manage your follow ups', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar and Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Center(
                              child: TextField(
                                controller: controller.searchController,
                                onChanged: (value) => controller.searchFollowups(value),
                                decoration: const InputDecoration(
                                  hintText: 'Search follow ups...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showAddEditBottomSheet(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF39C12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => controller.isFilterVisible.toggle(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.cardDarkBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.filter_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            Obx(() {
              if (!controller.isFilterVisible.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.5)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.filterType.value,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          items: ['All', 'Lead', 'Customer'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) controller.onFilterTypeChanged(value);
                          },
                        ),
                      ),
                    ),
                    if (controller.filterType.value != 'All') ...[
                      const SizedBox(height: 8),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            isExpanded: true,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Select ${controller.filterType.value}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            items: (controller.filterType.value == 'Lead' 
                                ? controller.leadsList 
                                : controller.customersList).map((item) {
                              final isLead = controller.filterType.value == 'Lead';
                              final id = isLead ? (item as Lead).id : (item as Customer).customerId;
                              
                              String displayName = 'Unknown';
                              if (isLead) {
                                final lead = item as Lead;
                                final name = lead.name ?? '';
                                final company = (lead.company != null && lead.company!.isNotEmpty) ? ' (${lead.company})' : '';
                                displayName = '$name$company'.trim();
                              } else {
                                final cust = item as Customer;
                                final fname = cust.firstname ?? '';
                                final lname = cust.lastname ?? '';
                                final name = '$fname $lname'.trim();
                                final company = cust.company ?? '';
                                displayName = '$company ($name)';
                              }

                              return DropdownMenuItem<int>(
                                value: int.tryParse(id?.toString() ?? ''),
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                  ),
                                  child: Text(displayName, style: const TextStyle(fontSize: 14)),
                                ),
                              );
                            }).toList(),
                            value: controller.selectedFilterId.value,
                            onChanged: (value) {
                              if (value != null) controller.onFilterEntitySelected(value);
                            },
                            dropdownSearchData: DropdownSearchData(
                              searchController: controller.filterSearchController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                                child: TextFormField(
                                  controller: controller.filterSearchController,
                                  expands: true,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    hintText: 'Search for an item...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                final child = item.child;
                                if (child is Container) {
                                  final textWidget = child.child as Text;
                                  return textWidget.data!.toLowerCase().contains(searchValue.toLowerCase());
                                }
                                return false;
                              },
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                controller.filterSearchController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // List of Follow ups
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredFollowups.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.fetchFollowups,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No Data Found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchFollowups,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisExtent: 84,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  itemCount: controller.filteredFollowups.length,
                  itemBuilder: (context, index) {
                    final followup = controller.filteredFollowups[index];
                    
                    String formattedDate = '';
                    if (followup.date != null && followup.date!.isNotEmpty) {
                      try {
                        DateTime dt = AppDateUtils.parseApiDate(followup.date!) ?? DateTime.parse(followup.date!).toLocal();
                        formattedDate = AppDateUtils.formatDateForUI(dt);
                      } catch (e) {
                        formattedDate = followup.date!;
                      }
                    }

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.notifications, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  followup.description ?? 'No Description',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _showAddEditBottomSheet(context, reminder: followup),
                                child: const Icon(Icons.edit_outlined, color: AppColors.cardDarkBlue, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${followup.firstname ?? ''} ${followup.lastname ?? ''}'.trim(),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          ],
        ),
      ),
    );
  }

  void _showAddEditBottomSheet(BuildContext context, {Reminder? reminder}) {
    final isEdit = reminder != null;
    
    String? apiDate;
    final dateController = TextEditingController();

    if (isEdit && reminder.date != null && reminder.date!.isNotEmpty) {
      try {
        DateTime dt = AppDateUtils.parseApiDate(reminder.date!) ?? DateTime.parse(reminder.date!).toLocal();
        apiDate = AppDateUtils.formatForApi(dt);
        dateController.text = AppDateUtils.formatDateTimeForUI(dt);
      } catch (e) {
        dateController.text = reminder.date!;
        apiDate = reminder.date;
      }
    }
    
    final descriptionController = TextEditingController(text: isEdit ? reminder.description : '');
    
    // State variables for dropdowns
    String? selectedRelType = isEdit ? reminder.relType : 'Lead';
    int? selectedRelId = isEdit && reminder.relId != null ? reminder.relId : null;
    int? selectedStaff = isEdit && reminder.staff != null ? reminder.staff : null;

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(builder: (context, setState) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20, 
              right: 20, 
              top: 20, 
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 
                  ? MediaQuery.of(context).viewInsets.bottom + 20 
                  : 20
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  isEdit ? 'Edit Follow Up' : 'Add Follow Up',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 20),
                
                // Description Field
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),

                // Date and Time Field
                const Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    DateTime initialDateTime = DateTime.now();
                    if (apiDate != null && apiDate!.isNotEmpty) {
                      try {
                        initialDateTime = DateTime.parse(apiDate!);
                      } catch (e) {
                        // ignore and use now
                      }
                    }

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.cardDarkBlue,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                              surface: Colors.white,
                            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.cardDarkBlue,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                                surface: Colors.white,
                              ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedTime != null) {
                        final dateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                        apiDate = AppDateUtils.formatForApi(dateTime);
                        
                        setState(() {
                          dateController.text = AppDateUtils.formatDateTimeForUI(dateTime);
                        });
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: 'Select Date & Time',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Rel Type (Only show on Add)
                if (!isEdit) ...[
                  const Text('Related To Type', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRelType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Customer', child: Text('Customer')),
                      DropdownMenuItem(value: 'Lead', child: Text('Lead')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRelType = value;
                        selectedRelId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Related Item Dropdown
                  Text('Related $selectedRelType', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton2<int>(
                      isExpanded: true,
                      hint: Text('Select $selectedRelType', style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
                      items: selectedRelType == 'Customer' 
                        ? controller.customersList.map((item) => DropdownMenuItem<int>(
                            value: item.customerId,
                            child: Text('${'${item.firstname ?? ''} ${item.lastname ?? ''}'.trim()} (${item.company ?? ''})', style: const TextStyle(fontSize: 14)),
                          )).toList()
                        : controller.leadsList.map((item) => DropdownMenuItem<int>(
                            value: item.id,
                            child: Text('${item.name ?? ''} (${item.company ?? ''})'.trim(), style: const TextStyle(fontSize: 14)),
                          )).toList(),
                      value: selectedRelId,
                      onChanged: (value) => setState(() => selectedRelId = value),
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(height: 40),
                      dropdownSearchData: DropdownSearchData(
                        searchController: TextEditingController(),
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              hintText: 'Search $selectedRelType...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.child as Text).data?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                        },
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],

                // Staff Dropdown
                const Text('Assign Staff', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    isExpanded: true,
                    hint: Text('Select Staff', style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
                    items: controller.staffList.map((Staff item) => DropdownMenuItem<int>(
                      value: item.staffid,
                      child: Text('${item.firstname} ${item.lastname}', style: const TextStyle(fontSize: 14)),
                    )).toList(),
                    value: selectedStaff,
                    onChanged: (value) => setState(() => selectedStaff = value),
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(height: 40),
                    dropdownSearchData: DropdownSearchData(
                      searchController: TextEditingController(),
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            hintText: 'Search staff...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.child as Text).data?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                      },
                    ),
                  ),
                )),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (descriptionController.text.isEmpty || apiDate == null || selectedStaff == null) {
                            Get.snackbar('Error', 'Please fill all required fields');
                            return;
                          }
                          
                          if (!isEdit && selectedRelId == null) {
                            Get.snackbar('Error', 'Please select a related item');
                            return;
                          }

                          bool success = false;
                          if (isEdit) {
                            success = await controller.updateReminder(
                              reminder.id!,
                              descriptionController.text,
                              apiDate!,
                              selectedStaff!,
                            );
                          } else {
                            success = await controller.addReminder(
                              descriptionController.text,
                              apiDate!,
                              selectedRelType ?? 'Customer',
                              selectedRelId!,
                              selectedStaff!,
                            );
                          }

                          if (success) {
                            Get.back();
                            Get.snackbar('Success', 'Follow up ${isEdit ? 'updated' : 'added'} successfully',
                                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                          } else {
                            Get.snackbar('Error', 'Failed to save follow up',
                                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardDarkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(isEdit ? 'Update' : 'Add', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
