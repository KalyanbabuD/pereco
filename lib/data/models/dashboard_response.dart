class DashboardResponse {
  final bool? status;
  final String? message;
  final DashboardData? resultData;

  DashboardResponse({this.status, this.message, this.resultData});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json['Status'],
      message: json['Message'],
      resultData: json['ResultData'] != null
          ? DashboardData.fromJson(json['ResultData'])
          : null,
    );
  }
}

class DashboardData {
  final int? totalLeads;
  final int? totalCustomers;
  final int? totalTodos;
  final int? totalReminders;
  final List<RecentLead>? recentLeads;
  final List<RecentCustomer>? recentCustomers;

  DashboardData({
    this.totalLeads,
    this.totalCustomers,
    this.totalTodos,
    this.totalReminders,
    this.recentLeads,
    this.recentCustomers,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalLeads: json['TotalLeads'],
      totalCustomers: json['TotalCustomers'],
      totalTodos: json['TotalTodos'],
      totalReminders: json['TotalReminders'],
      recentLeads: json['RecentLeads'] != null
          ? (json['RecentLeads'] as List).map((i) => RecentLead.fromJson(i)).toList()
          : null,
      recentCustomers: json['RecentCustomers'] != null
          ? (json['RecentCustomers'] as List).map((i) => RecentCustomer.fromJson(i)).toList()
          : null,
    );
  }
}

class RecentLead {
  final String? name;
  final String? title;
  final String? description;
  final String? company;
  final String? phoneNumber;
  final int? id;
  final String? pName;

  RecentLead({
    this.name,
    this.title,
    this.description,
    this.company,
    this.phoneNumber,
    this.id,
    this.pName,
  });

  factory RecentLead.fromJson(Map<String, dynamic> json) {
    return RecentLead(
      name: json['Name'],
      title: json['Title'],
      description: json['Description'],
      company: json['Company'],
      phoneNumber: json['PhoneNumber'],
      id: json['id'],
      pName: json['PName'],
    );
  }
}

class RecentCustomer {
  final int? customerId;
  final String? company;
  final String? phoneNumber;
  final int? country;
  final String? city;
  final String? zip;
  final String? state;
  final String? address;
  final String? website;
  final int? active;
  final int? contactId;
  final String? firstName;
  final String? lastName;
  final String? contactName;
  final String? email;
  final String? contactPhone;
  final String? title;

  RecentCustomer({
    this.customerId,
    this.company,
    this.phoneNumber,
    this.country,
    this.city,
    this.zip,
    this.state,
    this.address,
    this.website,
    this.active,
    this.contactId,
    this.firstName,
    this.lastName,
    this.contactName,
    this.email,
    this.contactPhone,
    this.title,
  });

  factory RecentCustomer.fromJson(Map<String, dynamic> json) {
    return RecentCustomer(
      customerId: json['customerId'],
      company: json['company'],
      phoneNumber: json['phonenumber'],
      country: json['country'],
      city: json['city'],
      zip: json['zip'],
      state: json['state'],
      address: json['address'],
      website: json['website'],
      active: json['active'],
      contactId: json['contactId'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      contactName: json['contactName'],
      email: json['email'],
      contactPhone: json['contactPhone'],
      title: json['title'],
    );
  }
}
