import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
   bool isRead;
  final DateTime sentAt;
  final String date; // formatted date


  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.sentAt,
    required this.date,

  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime sentAt = DateTime.parse(json['sent_at']);
    String formattedDate = "${sentAt.year.toString().padLeft(4,'0')}-${sentAt.month.toString().padLeft(2,'0')}-${sentAt.day.toString().padLeft(2,'0')}";

    return NotificationModel(
      id: json['notification_id'].toString(),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] ?? false,
      sentAt: sentAt,
      date: formattedDate,
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "notification_id": id,
      "title": title,
      "message": message,
      "type": type,
      "is_read": isRead,
      "sent_at": sentAt.toIso8601String(),
      "date": date,
    
    };
  }
}
