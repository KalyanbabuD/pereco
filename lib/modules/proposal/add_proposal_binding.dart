import 'package:get/get.dart';
import 'add_proposal_controller.dart';

class AddProposalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProposalController>(() => AddProposalController());
  }
}
