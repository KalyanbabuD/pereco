import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'settings_controller.dart';

class OrgSettingsView extends GetView<SettingsController> {
  const OrgSettingsView({super.key});

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

        final address = [
          data.invoiceCompanyAddress,
          data.invoiceCompanyCity,
          data.invoiceCompanyCountryCode,
          data.invoiceCompanyPostalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                padding: const EdgeInsets.all(32.0),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/org.jpg',
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.business,
                        size: 120,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Company Name
                    Text(
                      data.companyname ?? 'N/A',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Phone & GSTIN
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: AppColors.primaryOrange,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Phone',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.invoiceCompanyPhonenumber ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 16,
                                    color: AppColors.primaryOrange,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'GSTIN',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.gstin ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: Text(
                            address.isNotEmpty ? address : 'N/A',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
