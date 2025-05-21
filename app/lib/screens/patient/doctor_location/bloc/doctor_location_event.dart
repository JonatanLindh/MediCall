part of 'doctor_location_bloc.dart';

sealed class DoctorLocationEvent {}

final class DoctorLocationSubscribe extends DoctorLocationEvent {
  DoctorLocationSubscribe({required this.doctorId});

  final String doctorId;
}
