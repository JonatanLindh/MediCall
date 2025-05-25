import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';

part 'visits_state.dart';

class Visits extends Cubit<VisitsState> {
  Visits(this._doctorRepository) : super(const VisitsInitial());
  final DoctorRepository _doctorRepository;

  Future<void> getAllDoctors() async {
    emit(const VisitsLoading());

    emit(VisitsLoaded(await _doctorRepository.getAllVisits()));
  }
}
