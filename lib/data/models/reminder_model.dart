class ReminderResponse {
  final bool? status;
  final List<Reminder>? resultData;

  ReminderResponse({this.status, this.resultData});

  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    return ReminderResponse(
      status: json['Status'],
      resultData: json['ResultData'] != null
          ? (json['ResultData'] as List).map((i) => Reminder.fromJson(i)).toList()
          : null,
    );
  }
}

class Reminder {
  final int? id;
  final String? description;
  final String? date;
  final int? isNotified;
  final int? relId;
  final String? relType;
  final int? staff;
  final int? notifyByEmail;
  final int? creator;
  final String? firstname;
  final String? lastname;

  Reminder({
    this.id,
    this.description,
    this.date,
    this.isNotified,
    this.relId,
    this.relType,
    this.staff,
    this.notifyByEmail,
    this.creator,
    this.firstname,
    this.lastname,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      description: json['description'],
      date: json['date'],
      isNotified: json['isnotified'],
      relId: json['rel_id'],
      relType: json['rel_type'],
      staff: json['staff'],
      notifyByEmail: json['notify_by_email'],
      creator: json['creator'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
