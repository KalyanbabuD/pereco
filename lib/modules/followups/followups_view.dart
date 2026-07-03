import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'followups_controller.dart';
import '../dashboard/widgets/main_drawer.dart';

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
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.cardDarkBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                      color: Color(0xFFF39C12),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.search, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List of Follow ups
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredFollowups.isEmpty) {
                  return const Center(child: Text('No follow-ups found'));
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
                        DateTime dt = DateTime.parse(followup.date!);
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        formattedDate = '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
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
                              const Icon(Icons.edit_outlined, color: Colors.orange, size: 20),
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
}
