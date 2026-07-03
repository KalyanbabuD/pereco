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
    super.onClose();
  }

  void searchProposals(String query) {
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
