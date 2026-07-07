import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'settings_controller.dart';

class PreferencesView extends GetView<SettingsController> {
  const PreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final data = controller.orgSettings.value;
        if (data == null) {
          return const Center(child: Text('No Organization Data found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Regional Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cardDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPreferenceRow(
                        Icons.calendar_today,
                        'Date Format',
                        data.dateformat?.split('|').first ?? 'N/A',
                      ),
                      const Divider(height: 32),
                      _buildPreferenceRow(
                        Icons.access_time,
                        'Default Time Zone',
                        data.defaultTimezone ?? 'N/A',
                        iconColor: Colors.green,
                      ),
                      const Divider(height: 32),
                      _buildPreferenceRow(
                        Icons.language,
                        'Time Format',
                        '${data.timeFormat ?? 'N/A'} Hours',
                        iconColor: Colors.orange,
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            size: 20,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => _showTermsBottomSheet(
                                  context,
                                  'Invoice Terms & Conditions',
                                  data.predefinedTermsInvoice ??
                                      'No terms defined.',
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Invoice',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => _showTermsBottomSheet(
                                  context,
                                  'Estimate Terms & Conditions',
                                  data.predefinedTermsEstimate ??
                                      'No terms defined.',
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Estimate',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPreferenceRow(
    IconData icon,
    String title,
    String value, {
    Color iconColor = Colors.blue,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  void _showTermsBottomSheet(BuildContext context, String title, String terms) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: terms.split('\n').map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        point,
                        style: const TextStyle(
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}
