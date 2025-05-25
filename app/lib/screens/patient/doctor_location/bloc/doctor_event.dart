part of 'doctor_bloc.dart';

sealed class DoctorEvent {}

final class SetDoctorEvent extends DoctorEvent {
  SetDoctorEvent({required this.doctorId});

  final String doctorId;
}

final class DoctorLocationSubscribeEvent extends DoctorEvent {
  DoctorLocationSubscribeEvent();
}
