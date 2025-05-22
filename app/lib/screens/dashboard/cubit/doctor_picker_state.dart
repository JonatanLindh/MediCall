part of 'doctor_picker_cubit.dart';

sealed class DoctorPickerState extends Equatable {
  const DoctorPickerState(this.doctor);

  final Doctor? doctor;

  @override
  List<Object?> get props => [doctor];
}

final class DoctorPickerInitial extends DoctorPickerState {
  const DoctorPickerInitial(super.doctor);
}

final class DoctorPickerDoctors extends DoctorPickerState {
  const DoctorPickerDoctors(this.doctors, super.doctor);
  final List<Doctor> doctors;

  @override
  List<Object?> get props => [doctors, super.doctor];
}
