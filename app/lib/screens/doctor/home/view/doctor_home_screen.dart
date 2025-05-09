import 'package:flutter/material.dart';
import 'package:medicall/app/app_export.dart';


class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorName = "Dr. Nilsson";
    final nextPatientName = "Anna Ericsson";
    final nextAppointmentTime = "April 15, 10:00";

    final tasks = [
      {"icon": Icons.description, "text": "Review Sven’s Report"},
      {"icon": Icons.calendar_today, "text": "Confirm April 16 Appointment"},
      {"icon": Icons.chat, "text": "Respond to Patient Message"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Good morning",
              style:theme.textTheme.bodyLarge?.copyWith(
                fontSize: 26,
              ),
            ),
            Text(
              doctorName,
              style: theme.textTheme.headlineMedium
            ),
            const SizedBox(height: 20),
            Text("Next  Appointment", style: theme.textTheme.headlineMedium),
            Text(nextPatientName, style: theme.textTheme.bodyLarge),
            Text(nextAppointmentTime, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Go to report
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ),
                child:  Text(
                  "Anna Personal\nReport",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Today’s Tasks", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(tasks[index]["icon"] as IconData, color: Colors.blue),
                      title: Text(tasks[index]["text"] as String),
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
