class PaymentDetailsResponse {
  final bool? status;
  final PaymentDetails? resultData;

  PaymentDetailsResponse({this.status, this.resultData});

  factory PaymentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsResponse(
      status: json['Status'],
      resultData: json['ResultData'] != null && (json['ResultData'] as List).isNotEmpty
          ? PaymentDetails.fromJson((json['ResultData'] as List)[0])
          : null,
    );
  }
}

class PaymentDetails {
  final int? paymentsId;
  final int? invoiceNumber;
  final String? prefix;
  final String? amount;
  final String? paymentsModeName;
  final String? paymentdate;
  final String? transactionid;
  final String? paymentnote;
  final String? invoiceDate;
  final String? invoiceTotal;

  PaymentDetails({
    this.paymentsId,
    this.invoiceNumber,
    this.prefix,
    this.amount,
    this.paymentsModeName,
    this.paymentdate,
    this.transactionid,
    this.paymentnote,
    this.invoiceDate,
    this.invoiceTotal,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentsId: json['paymentsId'],
      invoiceNumber: json['invoiceNumber'] ?? json['number'],
      prefix: json['prefix'],
      amount: json['amount'],
      paymentsModeName: json['paymentsModeName'],
      paymentdate: json['paymentdate'],
      transactionid: json['transactionid'],
      paymentnote: json['paymentnote'],
      invoiceDate: json['date'],
      invoiceTotal: json['total'],
    );
  }
}
