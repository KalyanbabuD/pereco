import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../data/models/lead_details_models.dart';
import '../../core/network/api_endpoints.dart';

class LeadDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final Dio _dio = Dio();

  // Observables
  final isLoading = false.obs;
  final profile = Rx<LeadProfile?>(null);
  final proposals = <Proposal>[].obs;
  final followUps = <FollowUp>[].obs;
  final notes = <Note>[].obs;

  final proposalsSearch = ''.obs;
  final followUpsSearch = ''.obs;
  final notesSearch = ''.obs;

  int leadId = 0;

  @override
  void onInit() {
    super.onInit();
    
    int initialIndex = 0;
    
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['initialTabIndex'] != null) {
        initialIndex = Get.arguments['initialTabIndex'] as int;
      }
      if (Get.arguments['leadId'] != null) {
        leadId = Get.arguments['leadId'] as int;
      }
    }

    tabController = TabController(length: 4, vsync: this, initialIndex: initialIndex);
    
    fetchLeadDetails();
  }

  Future<void> fetchLeadDetails() async {
    print('Start fetching lead details for leadId: $leadId');
    isLoading.value = true;
    try {
      // Fetch Profile
      print('Fetching Profile from: ${ApiEndpoints.baseUrl}${ApiEndpoints.getLeadById}?LeadId=$leadId');
      final profileRes = await _dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getLeadById}?LeadId=$leadId');
      print('Profile response: ${profileRes.data}');
      if (profileRes.data['Status'] == true && profileRes.data['ResultData'] != null) {
        profile.value = LeadProfile.fromJson(profileRes.data['ResultData']);
        print('Profile loaded successfully');
      }

      // Fetch Proposals
      print('Fetching Proposals from: ${ApiEndpoints.baseUrl}${ApiEndpoints.getProposalsByRelId}?RelId=$leadId');
      final proposalsRes = await _dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getProposalsByRelId}?RelId=$leadId');
      print('Proposals response: ${proposalsRes.data}');
      if (proposalsRes.data['Status'] == true && proposalsRes.data['ResultData'] != null) {
        final list = proposalsRes.data['ResultData'] as List;
        proposals.value = list.map((e) => Proposal.fromJson(e)).toList();
        print('Proposals loaded successfully. Count: ${proposals.length}');
      }

      // Fetch Follow-Ups
      print('Fetching Follow-Ups from: ${ApiEndpoints.baseUrl}${ApiEndpoints.getReminders}?rel_id=$leadId&rel_type=Lead&staffid=0');
      final followUpsRes = await _dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getReminders}?rel_id=$leadId&rel_type=Lead&staffid=0');
      print('Follow-Ups response: ${followUpsRes.data}');
      if (followUpsRes.data['Status'] == true && followUpsRes.data['ResultData'] != null) {
        final list = followUpsRes.data['ResultData'] as List;
        followUps.value = list.map((e) => FollowUp.fromJson(e)).toList();
        print('Follow-Ups loaded successfully. Count: ${followUps.length}');
      }

      // Fetch Notes
      print('Fetching Notes from: ${ApiEndpoints.baseUrl}${ApiEndpoints.getNotes}?rel_id=$leadId&rel_type=Lead');
      final notesRes = await _dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getNotes}?rel_id=$leadId&rel_type=Lead');
      print('Notes response: ${notesRes.data}');
      if (notesRes.data['Status'] == true && notesRes.data['ResultData'] != null) {
        final list = notesRes.data['ResultData'] as List;
        notes.value = list.map((e) => Note.fromJson(e)).toList();
        print('Notes loaded successfully. Count: ${notes.length}');
      }
    } catch (e, stacktrace) {
      print('Error fetching lead details: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      isLoading.value = false;
      print('Done fetching lead details.');
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return 'N/A';
    try {
      if (dateStr.contains('T')) {
        DateTime date = DateTime.parse(dateStr);
        return '${date.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.year}';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
