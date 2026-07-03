class StaffResponse {
  bool? status;
  List<Staff>? resultData;
  String? message;

  StaffResponse({this.status, this.resultData, this.message});

  StaffResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['ResultData'] != null) {
      resultData = <Staff>[];
      json['ResultData'].forEach((v) {
        resultData!.add(Staff.fromJson(v));
      });
    }
    message = json['Message'];
  }
}

class Staff {
  int? staffid;
  String? email;
  String? firstname;
  String? lastname;
  String? phonenumber;

  Staff({
    this.staffid,
    this.email,
    this.firstname,
    this.lastname,
    this.phonenumber,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    staffid = json['staffid'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phonenumber = json['phonenumber'];
  }

  String get fullName => '${firstname ?? ''} ${lastname ?? ''}'.trim();
}
