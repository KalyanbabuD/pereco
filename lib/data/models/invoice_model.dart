class InvoiceResponse {
  final bool? status;
  final List<Invoice>? resultData;

  InvoiceResponse({this.status, this.resultData});

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      status: json['Status'] == true || json['Status'] == 1 || json['Status']?.toString().toLowerCase() == 'true',
      resultData: json['ResultData'] != null
          ? (json['ResultData'] as List).map((i) => Invoice.fromJson(i)).toList()
          : null,
    );
  }
}

class Invoice {
  final int? id;
  final int? clientid;
  final int? number;
  final String? prefix;
  final String? total;
  final String? clientName;

  Invoice({
    this.id,
    this.clientid,
    this.number,
    this.prefix,
    this.total,
    this.clientName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      clientid: json['clientid'],
      number: json['number'],
      prefix: json['prefix'],
      total: json['total']?.toString(),
      clientName: json['ClientName'],
    );
  }
}
