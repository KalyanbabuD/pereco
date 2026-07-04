import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_provider.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/models/lead_model.dart';
import '../../../data/models/staff_model.dart';
import '../../../data/models/product_model.dart';


class ProposalItem {
  final Product product;
  final RxInt qty = 1.obs;

  ProposalItem({required this.product});

  double get rate => double.tryParse(product.rate ?? '0') ?? 0;
  double get taxPercent => double.tryParse(product.tax?.toString() ?? '0') ?? 0;

  double get subtotal => qty.value * rate;
  double get taxAmount => subtotal * (taxPercent / 100);
  double get total => subtotal + taxAmount;
}

class AddProposalController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final isLoading = false.obs;

  // Dropdown data
  final customers = <Customer>[].obs;
  final leads = <Lead>[].obs;
  final staffList = <Staff>[].obs;
  final productsList = <Product>[].obs;

  // Selections
  final relType = 'Customer'.obs; // 'Customer' or 'Lead'
  final selectedCustomerId = Rxn<int>();
  final selectedLeadId = Rxn<int>();
  final selectedStaffId = Rxn<int>();
  final statusId = 1.obs; // Draft

  // Form Fields
  final subjectController = TextEditingController();
  final dateController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final contentController = TextEditingController();

  final selectedDate = Rxn<DateTime>();

  // Products List
  final selectedProduct = Rxn<Product>();
  final proposalItems = <ProposalItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchCustomers(),
      fetchLeads(),
      fetchStaff(),
      fetchProducts(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchCustomers() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getCustomers);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String ? jsonDecode(res.bodyString!) : res.body;
        final model = CustomerResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          customers.value = model.resultData!;
        }
      }
    } catch (e) {
      print('Error customers: $e');
    }
  }

  Future<void> fetchLeads() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getLeads);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String ? jsonDecode(res.bodyString!) : res.body;
        final model = LeadResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          leads.value = model.resultData!;
        }
      }
    } catch (e) {
      print('Error leads: $e');
    }
  }

  Future<void> fetchStaff() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getStaffDropdown);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String ? jsonDecode(res.bodyString!) : res.body;
        final model = StaffResponse.fromJson(data);
        if (model.status == true && model.resultData != null) {
          staffList.value = model.resultData!;
        }
      }
    } catch (e) {
      print('Error staff: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final res = await _apiProvider.get(ApiEndpoints.getProducts);
      if (res.statusCode == 200 && res.body != null) {
        final data = res.body is String ? jsonDecode(res.bodyString!) : res.body;
        final model = ProductResponse.fromJson(data);
        if (model.status == true && model.data != null) {
          productsList.value = model.data!;
        }
      }
    } catch (e) {
      print('Error products: $e');
    }
  }

  void onRelTypeChanged(String type) {
    relType.value = type;
    selectedCustomerId.value = null;
    selectedLeadId.value = null;
    clearAutoFill();
  }

  void onCustomerSelected(int? id) {
    selectedCustomerId.value = id;
    if (id != null) {
      final customer = customers.firstWhereOrNull((c) => c.customerId == id);
      if (customer != null) {
        emailController.text = customer.email ?? '';
        phoneController.text = customer.phonenumber ?? '';
        addressController.text = customer.address ?? '';
        cityController.text = customer.city ?? '';
        stateController.text = customer.state ?? '';
        zipController.text = customer.zip ?? '';
      }
    } else {
      clearAutoFill();
    }
  }

  void onLeadSelected(int? id) {
    selectedLeadId.value = id;
    if (id != null) {
      final lead = leads.firstWhereOrNull((l) => l.id == id);
      if (lead != null) {
        emailController.text = lead.email ?? '';
        phoneController.text = lead.phonenumber ?? '';
        addressController.text = lead.address ?? '';
        cityController.text = lead.city ?? '';
        stateController.text = lead.state ?? '';
        zipController.text = ''; // Leads usually don't have zip in the model list
      }
    } else {
      clearAutoFill();
    }
  }

  void clearAutoFill() {
    emailController.text = '';
    phoneController.text = '';
    addressController.text = '';
    cityController.text = '';
    stateController.text = '';
    zipController.text = '';
  }

  void addProduct(Product? product) {
    if (product == null) return;
    // Check if already added
    if (proposalItems.any((item) => item.product.id == product.id)) {
      Get.snackbar('Notice', 'Product already added', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    proposalItems.add(ProposalItem(product: product));
    selectedProduct.value = null; // reset dropdown
  }

  void removeProduct(ProposalItem item) {
    proposalItems.remove(item);
  }

  double get totalSubtotal {
    return proposalItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  double get totalTax {
    return proposalItems.fold(0, (sum, item) => sum + item.taxAmount);
  }

  double get grandTotal {
    return totalSubtotal + totalTax;
  }

  Future<void> submitProposal() async {
    if (subjectController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Subject is required', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (dateController.text.isEmpty) {
      Get.snackbar('Error', 'Date is required', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (relType.value == 'Customer' && selectedCustomerId.value == null) {
      Get.snackbar('Error', 'Please select a Customer', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (relType.value == 'Lead' && selectedLeadId.value == null) {
      Get.snackbar('Error', 'Please select a Lead', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (proposalItems.isEmpty) {
      Get.snackbar('Error', 'Please add at least one product', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final loginStaffId = prefs.getInt('staffid') ?? 0;

      String proposalTo = '';
      if (relType.value == 'Customer') {
        final c = customers.firstWhereOrNull((c) => c.customerId == selectedCustomerId.value);
        proposalTo = c?.company ?? c?.firstname ?? 'Customer';
      } else {
        final l = leads.firstWhereOrNull((l) => l.id == selectedLeadId.value);
        proposalTo = l?.name ?? l?.company ?? 'Lead';
      }

      final itemsPayload = proposalItems.map((item) {
        return {
          "item_id": item.product.id,
          "description": item.product.description ?? '',
          "long_description": item.product.longDescription ?? '',
          "qty": item.qty.value,
          "rate": item.rate,
          "unit": item.product.unit ?? ''
        };
      }).toList();

      final payload = {
        "subject": subjectController.text,
        "content": contentController.text,
        "addedfrom": loginStaffId,
        "assigned": selectedStaffId.value ?? 0,
        "subtotal": totalSubtotal,
        "total_tax": totalTax,
        "total": grandTotal,
        "adjustment": 0,
        "rel_id": relType.value == 'Customer' ? selectedCustomerId.value : selectedLeadId.value,
        "rel_type": relType.value.toLowerCase(),
        "proposal_to": proposalTo,
        "open_till": dateController.text, // e.g. "2026-07-04"
        "country": 1,
        "zip": zipController.text,
        "state": stateController.text,
        "city": cityController.text,
        "address": addressController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "status": statusId.value,
        "items": itemsPayload
      };

      final response = await _apiProvider.post(ApiEndpoints.addProposal, payload);

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back(result: true);
        Get.snackbar(
          'Success', 
          'Proposal added successfully', 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
      } else {
        Get.snackbar('Error', 'Failed to save proposal', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save proposal', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
