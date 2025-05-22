part of 'doctor_bloc.dart';

sealed class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object> get props => [];
}

final class DoctorLoading extends DoctorState {}

final class DoctorError extends DoctorState {
  const DoctorError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class DoctorAvailable extends DoctorState {
  const DoctorAvailable(this.position);

  final StrippedPosition position;

  @override
  List<Object> get props => [position];
}

final class DoctorsListState extends DoctorState {
  const DoctorsListState({required this.doctors});

  final List<Doctor> doctors;
}
