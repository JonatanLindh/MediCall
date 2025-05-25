import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/app_export.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/screens/doctor/home/view/task_status_button.dart';
import 'package:medicall/theme/theme_helper.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';
import 'package:medicall/screens/doctor/reports/view/doctor_reports_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorHomeScreenContent();
  }
}

class DoctorHomeScreenContent extends StatelessWidget {
  const DoctorHomeScreenContent({super.key});
  //context.read<DoctorReportsCubit>();

  @override
  Widget build(BuildContext context) {
    const doctorName = 'Dr. Johan Nilsson';
    // Get assigned tasks for this doctor
    //TODO : if the data is from the backend
    final state = context.watch<DoctorReportsCubit>().state;
    final assignedTasks = state.reports
        .where(
          (r) => r.assignedDoctorId == doctorName && !r.completed,
        )
        .toList();

    // Pick the first assigned task, or null if none
    //final currentTask = assignedTasks.isNotEmpty ? assignedTasks[0]:null;

    //final nextPatientName = currentTask?.name ?? 'No assigned patient';
    //final nextAppointmentTime = currentTask?.time ?? 'No appointment';
    final tasks = [
      {'icon': Icons.description, 'text': "Review Sven's Report"},
      {'icon': Icons.calendar_today, 'text': 'Confirm May 27 Appointment'},
      {'icon': Icons.chat, 'text': 'Respond to Patient Message'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Good morning',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 26,
              ),
            ),
            Text(
              doctorName,
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: 30),
            Center(
              child: AssignedTaskStatusButton(
                currentDoctorId:
                    'Dr. Johan Nilsson', // Replace with actual doctor ID
                onStatusChanged: (reportId, status) {
                  final cubit = context.read<DoctorReportsCubit>();
                  print('$reportId \n $status'); // Handle status change
                },
                //'Anna Personal\nReport',
                //textAlign: TextAlign.center,
                //style: theme.textTheme.titleMedium,
              ),
              //),
            ),
            //const SizedBox(height: 40),
            //Text('Next  Appointment: \n${nextPatientName} ${nextAppointmentTime}', style: theme.textTheme.bodyLarge),
            //Text(nextPatientName, style: theme.textTheme.bodyLarge),
            //Text(nextAppointmentTime, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 40),
            const Text(
              'Today’s Tasks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 00),
            Expanded(
              child: ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        tasks[index]['icon']! as IconData,
                        color: Colors.blue, // Use a consistent color
                      ),
                      title: Text(tasks[index]['text']! as String),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Handle task click
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
