import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/product_model.dart';

class ProductsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();

  // Used for tracking expanded cards
  final expandedCards = <int, bool>{}.obs;

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredProducts.length / itemsPerPage).ceil();

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredProducts.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredProducts.sublist(
        startIndex,
        endIndex > filteredProducts.length ? filteredProducts.length : endIndex);
  }

  void goToPage(int page) {
    currentPage.value = page;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void toggleExpanded(int index) {
    expandedCards[index] = !(expandedCards[index] ?? false);
    expandedCards.refresh();
  }

  void searchProducts(String query) {
    currentPage.value = 1;
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredProducts.value = products.where((p) {
        return (p.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.longDescription?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               (p.rate?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchProducts('');
  }

  Future<void> fetchProducts() async {
    try {
      currentPage.value = 1;
      isLoading.value = true;
      final response = await _apiProvider.get(ApiEndpoints.getProducts);

      if (response.statusCode == 200 && response.body != null) {
        final Map<String, dynamic> jsonResponse = response.body is Map<String, dynamic> 
            ? response.body 
            : response.body; // already decoded by get connect or similar if using dio/http
            
        final res = ProductResponse.fromJson(jsonResponse);
        if (res.status == true && res.data != null) {
          products.value = res.data!;
          filteredProducts.value = res.data!;
        }
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
