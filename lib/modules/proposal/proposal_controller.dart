import 'dart:convert';
import 'package:get/get.dart';
import '../../core/network/api_provider.dart';
import '../../core/network/api_endpoints.dart';
import '../../data/models/proposal_model.dart';
import 'package:flutter/material.dart';

class ProposalController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // List View Observables
  final proposals = <Proposal>[].obs;
  final filteredProposals = <Proposal>[].obs;
  final isLoadingList = true.obs;
  final TextEditingController searchController = TextEditingController();

  // Details View Observables
  final selectedProposalId = RxnInt();
  final proposalDetails = Rxn<ProposalDetailsResponse>();
  final isLoadingDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProposals();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Pagination
  final scrollController = ScrollController();
  final currentPage = 1.obs;
  final int itemsPerPage = 10;

  int get totalPages => (filteredProposals.length / itemsPerPage).ceil();

  List<Proposal> get paginatedProposals {
    if (filteredProposals.isEmpty) return [];
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    if (startIndex >= filteredProposals.length) return [];
    final endIndex = startIndex + itemsPerPage;
    return filteredProposals.sublist(
        startIndex,
        endIndex > filteredProposals.length ? filteredProposals.length : endIndex);
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) currentPage.value--;
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

  void searchProposals(String query) {
    currentPage.value = 1;
    if (query.isEmpty) {
      filteredProposals.value = proposals;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredProposals.value = proposals.where((proposal) {
        return (proposal.subject?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (proposal.proposalTo?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (proposal.relType?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (proposal.total?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchProposals('');
  }

  Future<void> fetchProposals() async {
    try {
      currentPage.value = 1;
      isLoadingList.value = true;
      final response = await _apiProvider.get(ApiEndpoints.getProposals);

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final proposalResponse = ProposalResponse.fromJson(jsonResponse);
        if (proposalResponse.status == true && proposalResponse.resultData != null) {
          proposals.value = proposalResponse.resultData!;
          filteredProposals.value = proposalResponse.resultData!;
        }
      }
    } catch (e) {
      print('Error fetching proposals: $e');
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> fetchProposalDetails(int id) async {
    try {
      selectedProposalId.value = id;
      isLoadingDetails.value = true;
      
      final response = await _apiProvider.get('${ApiEndpoints.getProposalDetails}/$id');

      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> jsonResponse;
        if (response.body is Map<String, dynamic>) {
          jsonResponse = response.body;
        } else {
          jsonResponse = jsonDecode(response.bodyString!);
        }

        final detailsResponse = ProposalDetailsResponse.fromJson(jsonResponse);
        proposalDetails.value = detailsResponse;
      }
    } catch (e) {
      print('Error fetching proposal details: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }
}
