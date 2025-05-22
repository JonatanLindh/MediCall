import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';
import 'package:medicall/repositories/geo/geo.dart';
import 'package:medicall/screens/dashboard/cubit/doctor_picker_cubit.dart';
import 'package:medicall/screens/patient/doctor_location/bloc/doctor_bloc.dart';

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
            const DoctorSelector(),
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
                  BlocBuilder<DoctorBloc, DoctorState>(
                    builder: (context, state) {
                      if (state is DoctorAvailable) {
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

class DoctorSelector extends StatelessWidget {
  const DoctorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DoctorRepository>(
      create: (context) => DoctorRepository(),
      child: Builder(
        builder: (context) {
          return BlocProvider<DoctorPickerCubit>(
            create: (context) => DoctorPickerCubit(
              RepositoryProvider.of<DoctorRepository>(context),
            )..getAllDoctors(),
            child: BlocBuilder<DoctorPickerCubit, DoctorPickerState>(
              builder: (context, state) {
                final selectedDoctor = state.doctor;
                var doctors = <Doctor>[];
                if (state is DoctorPickerDoctors) {
                  doctors = state.doctors;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose a Doctor:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<Doctor>(
                      value: selectedDoctor,
                      hint: const Text('Select a doctor'),
                      isExpanded: true,
                      items: doctors.map((doctor) {
                        return DropdownMenuItem<Doctor>(
                          value: doctor,
                          child: Text(doctor.name),
                        );
                      }).toList(),
                      onChanged: (doctor) {
                        if (doctor != null) {
                          context.read<DoctorPickerCubit>().setDoctor(doctor);
                        }
                      },
                    ),
                    if (selectedDoctor != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Selected: ${selectedDoctor.name}'),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
