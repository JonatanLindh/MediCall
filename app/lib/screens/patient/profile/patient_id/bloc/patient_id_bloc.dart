import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/patient/profile/patient_id/bloc/patient_id_event.dart';
import 'package:medicall/screens/patient/profile/patient_id/bloc/patient_id_state.dart';

class PatientIdBloc extends Bloc<PatientIdEvent, PatientIdState> {
  PatientIdBloc() : super(PatientIdInitial()) {
    on<LoadPatientIdData>((event, emit) {
      // Example state update
      emit(PatientIdLoaded('Sample data'));
    });
  }
}
