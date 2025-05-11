import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_id_event.dart';
import 'patient_id_state.dart';

class PatientIdBloc extends Bloc<PatientIdEvent, PatientIdState> {
  PatientIdBloc() : super(PatientIdInitial()) {
    on<LoadPatientIdData>((event, emit) {
      // Example state update
      emit(PatientIdLoaded("Sample data"));
    });
  }
}
