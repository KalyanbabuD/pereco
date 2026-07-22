class LeadStatusResponse {
  bool? status;
  List<LeadStatus>? resultData;
  String? message;

  LeadStatusResponse({this.status, this.resultData, this.message});

  LeadStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['ResultData'] != null) {
      resultData = <LeadStatus>[];
      json['ResultData'].forEach((v) {
        resultData!.add(LeadStatus.fromJson(v));
      });
    }
    message = json['Message'];
  }
}

class LeadStatus {
  int? id;
  String? name;

  LeadStatus({this.id, this.name});

  LeadStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
