import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../core/app_colors.dart';
import '../../data/models/todo_model.dart';
import 'todo_controller.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(isoString).toLocal();
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      final day = date.day.toString().padLeft(2, '0');
      final month = months[date.month - 1];
      final year = date.year;
      
      int hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'pm' : 'am';
      
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      final hourStr = hour.toString().padLeft(2, '0');
      
      return '$day $month $year, $hourStr:$minute $period';
    } catch (e) {
      if (isoString.length >= 10) {
        return isoString.substring(0, 10);
      }
      return isoString;
    }
  }

  void _showAddEditBottomSheet(BuildContext context, {Todo? todo}) {
    final isEdit = todo != null;
    final descriptionController = TextEditingController(text: isEdit ? todo.description : '');
    final formKey = GlobalKey<FormState>();
    
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Edit Todo' : 'Add Todo',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.cardDarkBlue),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardDarkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (isEdit) {
                          await controller.updateTodo(todo.todoid!, descriptionController.text);
                        } else {
                          await controller.addTodo(descriptionController.text);
                        }
                        Get.back();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
    );
  }

  void _showDeleteDialog(BuildContext context, int todoid) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this Todo?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await controller.deleteTodo(todoid);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStatusConfirmDialog(BuildContext context, Todo todo, bool isFinished) {
    final String statusStr = isFinished ? 'Pending' : 'Completed';
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Update Status'),
        content: Text('Are you sure you want to mark this Todo as $statusStr?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await controller.updateTodoStatus(todo.todoid!, isFinished ? 0 : 1);
              Get.back();
            },
            child: const Text('Yes', style: TextStyle(color: AppColors.cardDarkBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F8),
        elevation: 0,
        automaticallyImplyLeading: false, // In dashboard, leading is controlled by parent
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todo', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Manage your Leads', style: TextStyle(color: AppColors.cardDarkBlue, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.cardDarkBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              padding: EdgeInsets.zero,
              onPressed: () => _showAddEditBottomSheet(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdowns row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton2<int>(
                          value: controller.selectedStaffId.value,
                          isExpanded: true,
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 300,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: controller.staffSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: controller.staffSearchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              final text = (item.child as Text).data ?? '';
                              return text.toLowerCase().contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              controller.staffSearchController.clear();
                            }
                          },
                          items: [
                            const DropdownMenuItem<int>(
                              value: 0,
                              child: Text('All', style: TextStyle(color: Colors.black87)),
                            ),
                            ...controller.staffList.map((staff) {
                              return DropdownMenuItem<int>(
                                value: staff.staffid,
                                child: Text(staff.fullName, style: const TextStyle(color: Colors.black87)),
                              );
                            }),
                          ],
                          onChanged: controller.onStaffChanged,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedStatus.value,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          menuMaxHeight: 300,
                          icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade200),
                          items: const [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text('All', style: TextStyle(color: Colors.black87)),
                            ),
                            DropdownMenuItem<String>(
                              value: '1',
                              child: Text('Completed', style: TextStyle(color: Colors.black87)),
                            ),
                            DropdownMenuItem<String>(
                              value: '0',
                              child: Text('Pending', style: TextStyle(color: Colors.black87)),
                            ),
                          ],
                          onChanged: controller.onStatusChanged,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Search Bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.searchTodos,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF39C12), // Orange search button
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Todo Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredTodos.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.clearSearch();
                    },
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
                  onRefresh: () async {
                    controller.clearSearch();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 2;
                      }

                      final double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(controller.filteredTodos.length, (index) {
                          final todo = controller.filteredTodos[index];
                          final isFinished = todo.finished == 1;

                          return SizedBox(
                            width: itemWidth,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Checkbox
                                      GestureDetector(
                                        onTap: () => _showStatusConfirmDialog(context, todo, isFinished),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isFinished ? const Color(0xFFF39C12) : Colors.transparent, // Orange when finished
                                            border: Border.all(color: isFinished ? const Color(0xFFF39C12) : Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: isFinished
                                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Description
                                      Expanded(
                                        child: Text(
                                          todo.description ?? '',
                                          style: TextStyle(
                                            color: isFinished ? Colors.grey : AppColors.cardDarkBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            decoration: isFinished ? TextDecoration.lineThrough : null,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Actions
                                      GestureDetector(
                                        onTap: () => _showAddEditBottomSheet(context, todo: todo),
                                        child: const Icon(Icons.edit_square, color: AppColors.cardDarkBlue, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => _showDeleteDialog(context, todo.todoid!),
                                        child: const Icon(Icons.delete, color: AppColors.primaryRed, size: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Footer
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 14, color: AppColors.cardDarkBlue),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          todo.staffName ?? 'N/A',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(Icons.calendar_month, size: 14, color: AppColors.cardDarkBlue),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(todo.dateadded),
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  if (isFinished) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle, size: 14, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Completed on ${_formatDate(todo.datefinished)}',
                                            style: const TextStyle(color: Colors.green, fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
  }
}
