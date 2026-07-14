import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/utils/pdf_export_helper.dart';
import '../../core/utils/excel_export_helper.dart';
import '../../core/widgets/pagination_control.dart';
import 'products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: RefreshIndicator(
        onRefresh: controller.fetchProducts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cardDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your Products',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.filteredProducts.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = [];
                          for (final product in controller.filteredProducts) {
                            data.add([
                              product.description ?? '',
                              product.rate ?? '',
                              product.taxName ?? '',
                              product.unit ?? '',
                            ]);
                          }
                          
                          PdfExportHelper.openTablePdfPreview(
                            title: 'Products Data',
                            headers: ['Name', 'Rate', 'Tax', 'Unit'],
                            data: data,
                            filename: 'products_data.pdf',
                          );
                        },
                        child: Image.asset('assets/images/pdf_icon.png', height: 28, width: 28),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          if (controller.filteredProducts.isEmpty) {
                            Get.snackbar('Export', 'No data to export', snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.cardDarkBlue, colorText: Colors.white);
                            return;
                          }
                          
                          List<List<String>> data = [];
                          for (final product in controller.filteredProducts) {
                            data.add([
                              product.description ?? '',
                              product.rate ?? '',
                              product.taxName ?? '',
                              product.unit ?? '',
                            ]);
                          }
                          
                          ExcelExportHelper.shareTableExcel(
                            sheetName: 'Products Data',
                            headers: ['Name', 'Rate', 'Tax', 'Unit'],
                            data: data,
                            filename: 'ProductsData.xlsx',
                          );
                        },
                        child: Image.asset('assets/images/excel_icon.png', height: 28, width: 28),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Search Bar
              Container(
                height: 44,
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
                            onChanged: (value) => controller.searchProducts(value),
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
                      decoration: BoxDecoration(
                        color: const Color(0xFFF39C12),
                        borderRadius: BorderRadius.circular(8),
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

              // Grid List of Products
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredProducts.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.fetchProducts,
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
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
                    onRefresh: controller.fetchProducts,
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = (constraints.maxWidth / 450).ceil();
                        if (crossAxisCount < 1) crossAxisCount = 1;
                        double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;

                        return Column(
                          children: [
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                          children: List.generate(controller.paginatedProducts.length, (index) {
                            final product = controller.paginatedProducts[index];

                            return Obx(() {
                              final isExpanded = controller.expandedCards[index] ?? false;

                              return SizedBox(
                                width: itemWidth,
                                child: GestureDetector(
                                  onTap: () => controller.toggleExpanded(index),
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
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.blue.withOpacity(0.1),
                                          child: Text(
                                            _getInitials(product.description ?? ''),
                                            style: const TextStyle(
                                              color: AppColors.cardDarkBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.description ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: AppColors.cardDarkBlue,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹ ${product.rate ?? '0.00'}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  const Icon(Icons.receipt_long, size: 14, color: AppColors.cardDarkBlue),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    product.taxName ?? '',
                                                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.description, size: 14, color: AppColors.cardDarkBlue),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            (product.longDescription ?? '').replaceAll('\n', ' '),
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                            maxLines: isExpanded ? null : 1,
                                            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller.toggleExpanded(index),
                                          child: Icon(
                                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                            color: AppColors.cardDarkBlue,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                             ),
                            );
                            });
                          }),
                        ),
                        Obx(() => PaginationControl(
                              currentPage: controller.currentPage.value,
                              totalPages: controller.totalPages,
                              onPageChanged: controller.goToPage,
                            )),
                        ],
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
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'PR';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
