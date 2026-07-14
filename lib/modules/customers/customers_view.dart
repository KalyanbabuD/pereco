import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import '../../core/widgets/pagination_control.dart';
import 'customers_controller.dart';
import 'add_customer_view.dart';
import 'add_customer_controller.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      Get.snackbar(
        'Error',
        'Could not launch $urlString',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: RefreshIndicator(
        onRefresh: controller.fetchCustomers,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Text(
                        'Customers',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'Manage your customers',
                        style: TextStyle(
                          color: AppColors.cardDarkBlue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/pdf_icon.png',
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          if (controller.filteredCustomers.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          List<List<String>> data = [];
                          for (final customer in controller.filteredCustomers) {
                            data.add([
                              customer.company ?? 'N/A',
                              customer.phonenumber ?? '',
                              customer.email ?? '',
                              'NaN-NaN-NaN', // Created Date missing in model
                              customer.city ?? '',
                              customer.website ?? '',
                            ]);
                          }

                          PdfExportHelper.openTablePdfPreview(
                            title: 'Customers Data',
                            headers: [
                              'Company',
                              'Phone Number',
                              'email',
                              'Created Date',
                              'City',
                              'Website',
                            ],
                            data: data,
                            filename: 'customers_data.pdf',
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/excel_icon.png',
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          if (controller.filteredCustomers.isEmpty) {
                            Get.snackbar(
                              'Export',
                              'No data to export',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.cardDarkBlue,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          List<List<String>> data = [];
                          for (final customer in controller.filteredCustomers) {
                            data.add([
                              customer.company ?? 'N/A',
                              customer.phonenumber ?? '',
                              customer.email ?? '',
                              'NaN-NaN-NaN', // Created Date missing in model
                              customer.city ?? '',
                              customer.website ?? '',
                            ]);
                          }

                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Customers Data',
                            headers: [
                              'Company',
                              'Phone Number',
                              'email',
                              'Created Date',
                              'City',
                              'Website',
                            ],
                            data: data,
                            filename: 'CustomersData.xlsx',
                          );
                        },
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(
                          left: 8,
                        ), // small gap between excel and plus
                        decoration: BoxDecoration(
                          color: AppColors.cardDarkBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final result = await Get.bottomSheet(
                              GetBuilder<AddCustomerController>(
                                init: AddCustomerController(),
                                builder: (_) => const AddCustomerView(),
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );

                            if (result == true) {
                              Get.snackbar(
                                'Success',
                                'Customer added successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              controller.fetchCustomers();
                            }
                          },
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Cards
              Obx(() {
                final total = controller.customers.length;
                final active = controller.customers
                    .where((c) => c.active == 1)
                    .length;
                final inactive = total - active;

                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.currentFilter.value == 'Active') {
                            controller.setFilter('');
                          } else {
                            controller.setFilter('Active');
                          }
                        },
                        child: _buildStatCard(
                          '$active/$total',
                          'Active',
                          Icons.people,
                          Colors.green,
                          controller.currentFilter.value == 'Active',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.currentFilter.value == 'Inactive') {
                            controller.setFilter('');
                          } else {
                            controller.setFilter('Inactive');
                          }
                        },
                        child: _buildStatCard(
                          '$inactive',
                          'Inactive',
                          Icons.person_off,
                          Colors.red,
                          controller.currentFilter.value == 'Inactive',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.currentFilter.value == 'Total') {
                            controller.setFilter('');
                          } else {
                            controller.setFilter('Total');
                          }
                        },
                        child: _buildStatCard(
                          '$total',
                          'Total',
                          Icons.groups,
                          AppColors.cardDarkBlue,
                          controller.currentFilter.value == 'Total',
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Center(
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (value) =>
                                controller.searchCustomers(value),
                            decoration: const InputDecoration(
                              hintText: 'Search...',
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
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredCustomers.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Data Found',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.paginatedCustomers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final customer = controller.paginatedCustomers[index];

                        String initials = 'NA';
                        if (customer.company != null &&
                            customer.company!.isNotEmpty) {
                          initials = customer.company!
                              .substring(0, 1)
                              .toUpperCase();
                          if (customer.company!.length > 1) {
                            initials += customer.company!
                                .substring(1, 2)
                                .toUpperCase();
                          }
                        } else if (customer.contactName != null &&
                            customer.contactName!.isNotEmpty) {
                          initials = customer.contactName!
                              .substring(0, 1)
                              .toUpperCase();
                          if (customer.contactName!.length > 1) {
                            initials += customer.contactName!
                                .substring(1, 2)
                                .toUpperCase();
                          }
                        }

                        String displayPhone = customer.phonenumber ?? '';
                        if (displayPhone.contains(',')) {
                          displayPhone = displayPhone.split(',').first.trim();
                        } else if (displayPhone.contains('/')) {
                          displayPhone = displayPhone.split('/').first.trim();
                        }

                        return _buildCustomerCard(
                          id: customer.customerId ?? 0,
                          initials: initials,
                          org: customer.company ?? '',
                          location: customer.city ?? '',
                          contactName: customer.contactName != null
                              ? customer.contactName!.trim()
                              : '',
                          email: customer.email ?? '',
                          phone: displayPhone,
                          isActive: customer.active == 1,
                        );
                      },
                    ),
                    Obx(
                      () => PaginationControl(
                        currentPage: controller.currentPage.value,
                        totalPages: controller.totalPages,
                        onPageChanged: controller.goToPage,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String title,
    IconData icon,
    Color defaultColor,
    bool isSelected,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryOrange.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: defaultColor, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: defaultColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            const Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.check_circle,
                color: AppColors.cardDarkBlue,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard({
    required int id,
    required String initials,
    required String org,
    required String location,
    required String contactName,
    required String email,
    required bool isActive,
    String phone = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row (Avatar, Org, Menu)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(
                      '/customer-details',
                      arguments: {'initialTabIndex': 0, 'customerId': id},
                    )?.then((_) => controller.setFilter(''));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFE3EBF7),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              org,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.cardDarkBlue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.cardDarkBlue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location.isNotEmpty ? location : 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.cardDarkBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.cardDarkBlue,
                ),
                onSelected: (String result) {
                  int tabIndex = 0;
                  if (result == 'Profile') tabIndex = 0;
                  if (result == 'Contacts') tabIndex = 1;
                  if (result == 'Follow-Ups') tabIndex = 2;
                  if (result == 'Notes') tabIndex = 3;
                  Get.toNamed(
                    '/customer-details',
                    arguments: {'initialTabIndex': tabIndex, 'customerId': id},
                  )?.then((_) => controller.setFilter(''));
                },
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Profile',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF637381), size: 18),
                        SizedBox(width: 12),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Color(0xFF637381),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Contacts',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(
                          Icons.contacts,
                          color: Color(0xFF637381),
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Contacts',
                          style: TextStyle(
                            color: Color(0xFF637381),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Follow-Ups',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Color(0xFF637381),
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Follow-Ups',
                          style: TextStyle(
                            color: Color(0xFF637381),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Notes',
                    height: 42,
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: Color(0xFF637381),
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Notes',
                          style: TextStyle(
                            color: Color(0xFF637381),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // First Details Row: Email and Active Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (email.isNotEmpty && email != 'N/A')
                      _launchUrl('mailto:$email');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.mail,
                        size: 18,
                        color: AppColors.cardDarkBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email.isNotEmpty ? email : 'N/A',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Inactive',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          // Second Details Row: Contact Name and Phone
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18,
                      color: AppColors.cardDarkBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        contactName.isNotEmpty ? contactName : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (phone.isNotEmpty && phone != 'N/A')
                          _launchUrl('tel:$phone');
                      },
                      child: const Icon(
                        Icons.phone,
                        size: 18,
                        color: AppColors.cardDarkBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        phone.isNotEmpty ? phone : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (phone.isNotEmpty && phone != 'N/A')
                      GestureDetector(
                        onTap: () => _launchUrl('https://wa.me/$phone'),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Image.asset(
                            'assets/images/whatsapp_icon.png',
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
