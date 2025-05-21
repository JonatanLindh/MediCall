part of 'doctor_location_bloc.dart';

sealed class DoctorLocationState extends Equatable {
  const DoctorLocationState();

  @override
  List<Object> get props => [];
}

final class DoctorLocationLoading extends DoctorLocationState {}

final class DoctorLocationError extends DoctorLocationState {
  const DoctorLocationError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class DoctorLocationAvailable extends DoctorLocationState {
  const DoctorLocationAvailable(this.position);

  final StrippedPosition position;

  @override
  List<Object> get props => [position];
}
