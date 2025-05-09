import 'package:flutter/material.dart';
import 'package:medicall/screens/doctor/notifications/view/notification_item.dart';
import 'package:medicall/screens/doctor/notifications/view/notification_model.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationModel(
        status: NotificationStatus.emergency,
        title: 'New Emergency Report',
        message: 'Anna Ericsson reported suspected heart attack',
      ),
      NotificationModel(
        status: NotificationStatus.reminder,
        title: 'Reminder',
        message: "Follow up with Anna Ericsson's report",
      ),
      NotificationModel(
        status: NotificationStatus.resolved,
        title: 'Resolved',
        message: 'Case for Sven Pettersson marked as completed',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return NotificationItem(item: item);
        },
        separatorBuilder: (_, __) => const Divider(height: 24),
      ),
    );
  }
}
