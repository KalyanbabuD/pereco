class LeadResponse {
  final List<Lead>? resultData;
  final String? message;
  final bool? status;

  LeadResponse({
    this.resultData,
    this.message,
    this.status,
  });

  factory LeadResponse.fromJson(Map<String, dynamic> json) {
    return LeadResponse(
      resultData: json['ResultData'] != null
          ? List<Lead>.from(json['ResultData'].map((x) => Lead.fromJson(x)))
          : null,
      message: json['Message'],
      status: json['Status'],
    );
  }
}

class Lead {
  final int? id;
  final String? name;
  final String? title;
  final String? company;
  final String? email;
  final String? phonenumber;
  final String? city;
  final String? state;
  final String? address;
  final String? dateadded;
  final int? statusId;
  final int? sourceId;
  final String? sourceName;
  final String? statusName;
  final String? assignedTo;

  Lead({
    this.id,
    this.name,
    this.title,
    this.company,
    this.email,
    this.phonenumber,
    this.city,
    this.state,
    this.address,
    this.dateadded,
    this.statusId,
    this.sourceId,
    this.sourceName,
    this.statusName,
    this.assignedTo,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      company: json['company']?.toString(), // Handle if it comes as int or String
      email: json['email'],
      phonenumber: json['phonenumber'],
      city: json['city'],
      state: json['state'],
      address: json['address'],
      dateadded: json['dateadded'],
      statusId: json['statusId'],
      sourceId: json['sourceId'],
      sourceName: json['SourceName'],
      statusName: json['StatusName'],
      assignedTo: json['AssignedTo'],
    );
  }
}
