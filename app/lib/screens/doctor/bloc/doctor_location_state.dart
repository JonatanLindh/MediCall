part of 'doctor_location_bloc.dart';

@immutable
sealed class DoctorLocationState {}

final class DoctorLocationInitial extends DoctorLocationState {
  DoctorLocationInitial() {
    print('DoctorLocationInitial');
  }
}
