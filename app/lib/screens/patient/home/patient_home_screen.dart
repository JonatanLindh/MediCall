import 'package:flutter/material.dart';
import 'package:medicall/app/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediCall Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to MediCall 👩‍⚕️🩺',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LoginRoute().go(context);
              },
              child: const Text('Click me to Login'),
            ),
            ElevatedButton(
              onPressed: () {
                const PatientTimelineRoute(reportId: '1', status: 'departure')
                    .go(context);
              },
              child: const Text('Go to Timeline'),
            ),
          ],
        ),
      ),
    );
  }
}
