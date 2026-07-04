class DropdownItem {
  final int id;
  final String name;

  DropdownItem({required this.id, required this.name});

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    // Try common keys for id
    final id = json['id'] ?? 
               json['categoryid'] ?? 
               json['taxid'] ?? 
               json['currencyid'] ?? 
               json['paymentmodeid'] ?? 
               json['userid'] ??
               json['staffid'] ??
               json['customerId'] ?? 
               json['clientid'] ?? 
               0;
               
    // Try common keys for name
    final name = json['name'] ?? 
                 json['category_name'] ?? 
                 json['tax_name'] ?? 
                 json['currency_name'] ?? 
                 json['payment_mode_name'] ?? 
                 json['company'] ??
                 json['firstname'] ?? 
                 '';
    final symbol = json['symbol'] ?? '';
    final nameStr = name.toString();
    final formattedName = symbol.toString().isNotEmpty ? '$nameStr (${symbol.toString()})' : nameStr;
                 
    return DropdownItem(
      id: id is int ? id : int.tryParse(id.toString()) ?? 0,
      name: formattedName,
    );
  }
}

class DropdownResponse {
  final bool? status;
  final List<DropdownItem>? resultData;
  final String? message;

  DropdownResponse({this.status, this.resultData, this.message});

  factory DropdownResponse.fromJson(Map<String, dynamic> json) {
    List<DropdownItem>? data;
    final results = json['ResultData'] ?? json['Data'];
    if (results != null) {
      data = <DropdownItem>[];
      results.forEach((v) {
        data!.add(DropdownItem.fromJson(v));
      });
    }
    return DropdownResponse(
      status: json['Status'],
      resultData: data,
      message: json['Message'],
    );
  }
}
