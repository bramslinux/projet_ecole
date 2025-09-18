import 'package:flutter/material.dart';

enum NotificationType {
  event,
  academic,
  system,
  alert,
}

extension NotificationTypeExtension on NotificationType {
  Color get color {
    switch (this) {
      case NotificationType.event:
        return Colors.blue;
      case NotificationType.academic:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
      case NotificationType.alert:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.academic:
        return Icons.school;
      case NotificationType.system:
        return Icons.computer;
      case NotificationType.alert:
        return Icons.warning;
    }
  }

  String get label {
    switch (this) {
      case NotificationType.event:
        return 'Événement';
      case NotificationType.academic:
        return 'Académique';
      case NotificationType.system:
        return 'Système';
      case NotificationType.alert:
        return 'Alerte';
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;
  final bool isRead;
  final String? targetUrl;
  final Map<String, dynamic>? additionalData;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
    this.targetUrl,
    this.additionalData,
  });

  NotificationItem copyWith({
    String? title,
    String? message,
    DateTime? date,
    NotificationType? type,
    bool? isRead,
    String? targetUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return NotificationItem(
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      targetUrl: targetUrl ?? this.targetUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'isRead': isRead,
      'targetUrl': targetUrl,
      'additionalData': additionalData,
    };
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      isRead: json['isRead'] ?? false,
      targetUrl: json['targetUrl'],
      additionalData: json['additionalData'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationItem &&
        other.title == title &&
        other.message == message &&
        other.date == date &&
        other.type == type &&
        other.isRead == isRead &&
        other.targetUrl == targetUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        message.hashCode ^
        date.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        targetUrl.hashCode;
  }
}
