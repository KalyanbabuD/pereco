class LoginResponse {
  final String? message;
  final ResultData? resultData;
  final bool? status;

  LoginResponse({this.message, this.resultData, this.status});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      resultData: json['ResultData'] != null
          ? ResultData.fromJson(json['ResultData'])
          : null,
      status: json['Status'],
    );
  }
}

class ResultData {
  final int? staffId;
  final String? email;
  final String? firstName;
  final String? lastName;

  ResultData({this.staffId, this.email, this.firstName, this.lastName});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      staffId: json['staffid'],
      email: json['email'],
      firstName: json['firstname'],
      lastName: json['lastname'],
    );
  }
}
