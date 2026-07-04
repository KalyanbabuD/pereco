class LeadSourceResponse {
  bool? status;
  List<LeadSource>? resultData;
  String? message;

  LeadSourceResponse({this.status, this.resultData, this.message});

  LeadSourceResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['ResultData'] != null) {
      resultData = <LeadSource>[];
      json['ResultData'].forEach((v) {
        resultData!.add(LeadSource.fromJson(v));
      });
    }
    message = json['Message'];
  }
}

class LeadSource {
  int? id;
  String? name;

  LeadSource({this.id, this.name});

  LeadSource.fromJson(Map<String, dynamic> json) {
    id = json['SourceId'];
    name = json['SourceName'];
  }
}
