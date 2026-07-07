class CreditNoteResponse {
  final List<CreditNote>? resultData;
  final String? message;
  final bool? status;

  CreditNoteResponse({
    this.resultData,
    this.message,
    this.status,
  });

  factory CreditNoteResponse.fromJson(Map<String, dynamic> json) {
    return CreditNoteResponse(
      resultData: json['ResultData'] != null
          ? List<CreditNote>.from(json['ResultData'].map((x) => CreditNote.fromJson(x)))
          : null,
      message: json['Message'],
      status: json['Status'] == true || json['Status'] == 1 || json['Status']?.toString().toLowerCase() == 'true',
    );
  }
}

class CreditNote {
  final int? id;
  final int? clientid;
  final String? prefix;
  final int? number;
  final String? date;
  final String? total;
  final String? clientnote;
  final int? status;
  final String? clientName;
  final String? addedByName;

  CreditNote({
    this.id,
    this.clientid,
    this.prefix,
    this.number,
    this.date,
    this.total,
    this.clientnote,
    this.status,
    this.clientName,
    this.addedByName,
  });

  factory CreditNote.fromJson(Map<String, dynamic> json) {
    return CreditNote(
      id: json['id'],
      clientid: json['clientid'],
      prefix: json['prefix'],
      number: json['number'],
      date: json['date'],
      total: json['total']?.toString(),
      clientnote: json['clientnote'],
      status: json['status'],
      clientName: json['ClientName'],
      addedByName: json['AddedByName'],
    );
  }
}
