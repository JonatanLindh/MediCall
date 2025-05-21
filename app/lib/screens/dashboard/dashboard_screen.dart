import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/repositories/geo/bloc/geo_bloc.dart';
import 'package:medicall/repositories/geo/repo/geo_repository.dart';
import 'package:medicall/screens/patient/doctor_location/bloc/doctor_location_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorLocationBloc(
        geoRepository: context.read<GeoRepository>(),
      )..add(DoctorLocationSubscribe(doctorId: 'cmav7q0450000woy0jw7em246')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // NAVIGATE TO CALL SCREEN
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                ),
                child: const Text('CALL FOR HELP'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Staff is on the way',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              BlocBuilder<DoctorLocationBloc, DoctorLocationState>(
                builder: (context, state) {
                  if (state is DoctorLocationAvailable) {
                    return Column(
                      children: [
                        const Text(
                          'Doctor Location:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Latitude: ${state.position.latitude}, Longitude: ${state.position.longitude}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
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
              BlocBuilder<GeoBloc, GeoState>(
                builder: (context, state) {
                  if (state is GeoGotPosition) {
                    return Column(
                      children: [
                        const Text(
                          'Current Location:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Latitude: ${state.position.latitude}, Longitude: ${state.position.longitude}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}
