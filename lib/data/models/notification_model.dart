class NotificationResponse {
  final bool status;
  final int receivedCount;
  final int sentCount;
  final List<NotificationItem> receivedNotifications;
  final List<NotificationItem> sentNotifications;

  NotificationResponse({
    required this.status,
    required this.receivedCount,
    required this.sentCount,
    required this.receivedNotifications,
    required this.sentNotifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['Status'] ?? false,
      receivedCount: json['ReceivedCount'] ?? 0,
      sentCount: json['SentCount'] ?? 0,
      receivedNotifications: (json['ReceivedNotifications'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList() ??
          [],
      sentNotifications: (json['SentNotifications'] as List<dynamic>?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class NotificationItem {
  final int id;
  final int isRead;
  final int isReadInline;
  final String date;
  final String description;
  final int fromUserId;
  final int fromClientId;
  final String fromFullName;
  final int toUserId;
  final int? fromCompany;
  final String link;
  final String additionalData;
  final String fromStaffName;
  final String toStaffName;

  NotificationItem({
    required this.id,
    required this.isRead,
    required this.isReadInline,
    required this.date,
    required this.description,
    required this.fromUserId,
    required this.fromClientId,
    required this.fromFullName,
    required this.toUserId,
    this.fromCompany,
    required this.link,
    required this.additionalData,
    required this.fromStaffName,
    required this.toStaffName,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      isRead: json['isread'] ?? 0,
      isReadInline: json['isread_inline'] ?? 0,
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      fromUserId: json['fromuserid'] ?? 0,
      fromClientId: json['fromclientid'] ?? 0,
      fromFullName: json['from_fullname'] ?? '',
      toUserId: json['touserid'] ?? 0,
      fromCompany: json['fromcompany'],
      link: json['link'] ?? '',
      additionalData: json['additional_data'] ?? '',
      fromStaffName: json['FromStaffName'] ?? '',
      toStaffName: json['ToStaffName'] ?? '',
    );
  }
}
