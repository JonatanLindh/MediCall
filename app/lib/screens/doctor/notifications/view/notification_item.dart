import 'package:flutter/material.dart';
import 'notification_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({required this.item, super.key});

  final NotificationModel item;

  IconData getIcon(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.emergency:
        return Icons.warning_amber_rounded;
      case NotificationStatus.reminder:
        return Icons.alarm;
      case NotificationStatus.resolved:
        return Icons.check_circle;
    }
  }

  Color getColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.emergency:
        return Colors.redAccent;
      case NotificationStatus.reminder:
        return Colors.orangeAccent;
      case NotificationStatus.resolved:
        return Colors.green;
    }
  }

  Color getBackground(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.emergency:
        return Colors.red.shade50;
      case NotificationStatus.reminder:
        return Colors.orange.shade50;
      case NotificationStatus.resolved:
        return Colors.green.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      color: getBackground(item.status),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              getIcon(item.status),
              size: 28,
              color: getColor(item.status),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: getColor(item.status),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
