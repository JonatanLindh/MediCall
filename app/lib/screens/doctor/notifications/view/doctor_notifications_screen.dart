import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/call/call_repository.dart';
import 'package:medicall/screens/doctor/notifications/cubit/incoming_calls_cubit.dart';
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
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return NotificationItem(item: item);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
          const Expanded(child: IncomingCallsWidget()),
        ],
      ),
    );
  }
}

class IncomingCallsWidget extends StatelessWidget {
  const IncomingCallsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          IncomingCallsCubit(CallRepository())..getAllIncomingCalls(),
      child: BlocBuilder<IncomingCallsCubit, IncomingCallsState>(
        builder: (context, state) {
          if (state is IncomingCallsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is IncomingCallsInitial ||
              state is! IncomingCallsLoaded ||
              state.incomingCalls.isEmpty) {
            return const Text('No incoming calls');
          }
          final calls = state.incomingCalls;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: calls.length,
            itemBuilder: (context, index) {
              final call = calls[index];
              return ListTile(
                leading: const Icon(Icons.call, color: Colors.green),
                title: Text(call),
                trailing: ElevatedButton(
                  onPressed: () {
                    CallRoute(roomNameToConnect: call).push<void>(context);
                  },
                  child: const Text('Accept'),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
