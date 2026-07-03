class PaymentResponse {
  final bool? status;
  final List<Payment>? resultData;

  PaymentResponse({this.status, this.resultData});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['Status'],
      resultData: json['ResultData'] != null
          ? (json['ResultData'] as List).map((i) => Payment.fromJson(i)).toList()
          : null,
    );
  }
}

class Payment {
  final int? id;
  final int? invoiceid;
  final String? amount;
  final String? paymentmode;
  final String? paymentmethod;
  final String? date;
  final String? daterecorded;
  final String? note;
  final String? transactionid;
  final String? paymentModeName;
  final int? invoiceNumber;
  final String? invoicePrefix;

  Payment({
    this.id,
    this.invoiceid,
    this.amount,
    this.paymentmode,
    this.paymentmethod,
    this.date,
    this.daterecorded,
    this.note,
    this.transactionid,
    this.paymentModeName,
    this.invoiceNumber,
    this.invoicePrefix,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceid: json['invoiceid'],
      amount: json['amount'],
      paymentmode: json['paymentmode'],
      paymentmethod: json['paymentmethod'],
      date: json['date'],
      daterecorded: json['daterecorded'],
      note: json['note'],
      transactionid: json['transactionid'],
      paymentModeName: json['PaymentModeName'],
      invoiceNumber: json['InvoiceNumber'],
      invoicePrefix: json['InvoicePrefix'],
    );
  }
}
