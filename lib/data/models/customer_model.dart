class CustomerResponse {
  final List<Customer>? resultData;
  final String? message;
  final bool? status;

  CustomerResponse({
    this.resultData,
    this.message,
    this.status,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      resultData: json['ResultData'] != null
          ? List<Customer>.from(json['ResultData'].map((x) => Customer.fromJson(x)))
          : null,
      message: json['Message'],
      status: json['Status'],
    );
  }
}

class Customer {
  final int? customerId;
  final String? company;
  final String? phonenumber;
  final int? country;
  final String? city;
  final String? zip;
  final String? state;
  final String? address;
  final String? website;
  final int? active;
  final int? contactId;
  final String? firstname;
  final String? lastname;
  final String? contactName;
  final String? email;
  final String? contactPhone;
  final String? title;

  // Billing and Shipping (from GetCustomerDetails)
  final String? billingStreet;
  final String? billingCity;
  final String? billingState;
  final String? billingZip;
  final String? shippingStreet;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingZip;

  Customer({
    this.customerId,
    this.company,
    this.phonenumber,
    this.country,
    this.city,
    this.zip,
    this.state,
    this.address,
    this.website,
    this.active,
    this.contactId,
    this.firstname,
    this.lastname,
    this.contactName,
    this.email,
    this.contactPhone,
    this.title,
    this.billingStreet,
    this.billingCity,
    this.billingState,
    this.billingZip,
    this.shippingStreet,
    this.shippingCity,
    this.shippingState,
    this.shippingZip,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'],
      company: json['company'],
      phonenumber: json['phonenumber'],
      country: json['country'],
      city: json['city'],
      zip: json['zip']?.toString(),
      state: json['state'],
      address: json['address'],
      website: json['website'],
      active: json['active'],
      contactId: json['contactId'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      contactName: json['contactName'],
      email: json['email'],
      contactPhone: json['contactPhone'],
      title: json['title'],
      billingStreet: json['billing_street'],
      billingCity: json['billing_city'],
      billingState: json['billing_state'],
      billingZip: json['billing_zip']?.toString(),
      shippingStreet: json['shipping_street'],
      shippingCity: json['shipping_city'],
      shippingState: json['shipping_state'],
      shippingZip: json['shipping_zip']?.toString(),
    );
  }
}
