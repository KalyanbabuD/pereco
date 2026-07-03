class ExpenseResponse {
  bool? status;
  List<Expense>? resultData;
  String? message;

  ExpenseResponse({this.status, this.resultData, this.message});

  ExpenseResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['ResultData'] != null) {
      resultData = <Expense>[];
      json['ResultData'].forEach((v) {
        resultData!.add(Expense.fromJson(v));
      });
    }
    message = json['Message'];
  }
}

class Expense {
  int? id;
  int? category;
  String? expenseCategoryName;
  int? currency;
  String? amount;
  int? tax;
  String? taxName;
  String? note;
  String? expenseName;
  int? clientid;
  String? clientName;
  int? projectId;
  String? paymentmode;
  String? paymentModeName;
  String? date;

  Expense({
    this.id,
    this.category,
    this.expenseCategoryName,
    this.currency,
    this.amount,
    this.tax,
    this.taxName,
    this.note,
    this.expenseName,
    this.clientid,
    this.clientName,
    this.projectId,
    this.paymentmode,
    this.paymentModeName,
    this.date,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    expenseCategoryName = json['expense_category_name'];
    currency = json['currency'];
    amount = json['amount']?.toString();
    tax = json['tax'];
    taxName = json['taxName'];
    note = json['note'];
    expenseName = json['expense_name'];
    clientid = json['clientid'];
    clientName = json['client_name'];
    projectId = json['project_id'];
    paymentmode = json['paymentmode']?.toString();
    paymentModeName = json['payment_mode_name'];
    date = json['date'];
  }
}
