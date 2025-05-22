import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';

part 'doctor_picker_state.dart';

class DoctorPickerCubit extends Cubit<DoctorPickerState> {
  DoctorPickerCubit(this._doctorRepository)
      : super(const DoctorPickerInitial(null));
  final DoctorRepository _doctorRepository;

  void setDoctor(Doctor doctor) {
    _doctorRepository.setSelectedDoctor(doctor);
    getAllDoctors();
  }

  void getAllDoctors() {
    final doctor = _doctorRepository.getSelectedDoctor();
    print(doctor);
    emit(DoctorPickerDoctors(_doctorRepository.getAllDoctors(), doctor));
  }
}
