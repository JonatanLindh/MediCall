enum NotificationStatus { emergency, reminder, resolved }

class NotificationModel {
  final NotificationStatus status;
  final String title;
  final String message;

  NotificationModel({
    required this.status,
    required this.title,
    required this.message,
  });
}
