import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/app_export.dart';
import 'package:medicall/screens/doctor/home/view/task_status_button.dart';
import 'package:medicall/theme/theme_helper.dart';
import 'package:medicall/screens/doctor/reports/cubit/doctor_reports_cubit.dart';
import 'package:medicall/screens/doctor/reports/view/doctor_reports_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the home screen with BlocProvider and provide the doctor ID
    return BlocProvider(
      create: (_) => DoctorReportsCubit(),
      child: const DoctorHomeScreenContent(),
    );
  }
}

class DoctorHomeScreenContent extends StatelessWidget {
  const DoctorHomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    const doctorName = 'Dr. Nilsson';
    const nextPatientName = 'Anna Ericsson';
    const nextAppointmentTime = 'April 15, 10:00';

    final tasks = [
      {'icon': Icons.description, 'text': "Review Sven's Report"},
      {'icon': Icons.calendar_today, 'text': 'Confirm April 16 Appointment'},
      {'icon': Icons.chat, 'text': 'Respond to Patient Message'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
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
            const SizedBox(height: 60),
            Text('Next  Appointment', style: theme.textTheme.headlineMedium),
            Text(nextPatientName, style: theme.textTheme.bodyLarge),
            Text(nextAppointmentTime, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 40),
            Center(
              //child: ElevatedButton(
              //  onPressed: () {
              //    // Go to report
             //     final cubit=context.read<DoctorReportsCubit>();
              //  },
              //  style: ElevatedButton.styleFrom(
              //    backgroundColor: Colors.blue,
              //    shape: RoundedRectangleBorder(
              //      borderRadius: BorderRadius.circular(25),
              //    ),
              //    padding:
              //        const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              //  ),
                child: AssignedTaskStatusButton(
                  currentDoctorId: 'Dr. Johan Nilsson',// Replace with actual doctor ID
                  onStatusChanged: (reportId, status) {
                    final cubit=context.read<DoctorReportsCubit>();
                    print("$reportId \n $status");// Handle status change
                  },
                  //'Anna Personal\nReport',
                  //textAlign: TextAlign.center,
                  //style: theme.textTheme.titleMedium,
                ),
              //),
            ),
            const SizedBox(height: 50),
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
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        tasks[index]['icon']! as IconData,
                        color: Colors.blue,
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
