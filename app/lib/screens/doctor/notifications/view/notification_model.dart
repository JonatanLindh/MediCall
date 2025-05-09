enum NotificationStatus { emergency, reminder, resolved }

class NotificationModel {
  NotificationModel({
    required this.status,
    required this.title,
    required this.message,
  });

  final NotificationStatus status;
  final String title;
  final String message;
}
