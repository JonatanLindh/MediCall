import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/geo/geo.dart';
import 'package:medicall/screens/patient/doctor_location/bloc/doctor_location_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  CallRoute().push<void>(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                ),
                child: const Text(
                  'CALL FOR HELP',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Staff is on the way',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<GeoBloc, GeoState>(
              builder: (context, state) {
                if (state is GeoGotPosition) {
                  return PositionShower(
                    title: 'Patient Location',
                    position: StrippedPosition.fromPosition(state.position),
                  );
                } else if (state is GeoError) {
                  return const Text(
                    'Error getting location',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is GeoLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('No location data available');
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                PatientTimelineRoute().push<void>(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<DoctorLocationBloc, DoctorLocationState>(
                    builder: (context, state) {
                      if (state is DoctorLocationAvailable) {
                        return PositionShower(
                          title: 'Doctor Location',
                          position: state.position,
                        );
                      } else if (state is GeoError) {
                        return const Text(
                          'Error getting location',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (state is GeoLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text('No location data available');
                      }
                    },
                  ),
                  const Text(
                    'Press to go to timeline',
                    style: TextStyle(
                      fontSize: 20,
                    ),
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

class PositionShower extends StatelessWidget {
  const PositionShower({
    required this.position,
    required this.title,
    super.key,
  });

  final String title;
  final StrippedPosition position;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 30),
        ),
        Text(
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
