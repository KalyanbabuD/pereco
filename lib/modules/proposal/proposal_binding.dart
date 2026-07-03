import 'package:get/get.dart';
import 'proposal_controller.dart';

class ProposalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProposalController>(() => ProposalController());
  }
}
