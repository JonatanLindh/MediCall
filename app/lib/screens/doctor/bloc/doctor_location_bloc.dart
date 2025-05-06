import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'doctor_location_event.dart';
part 'doctor_location_state.dart';

class DoctorLocationBloc
    extends Bloc<DoctorLocationEvent, DoctorLocationState> {
  DoctorLocationBloc() : super(DoctorLocationInitial()) {
    on<DoctorLocationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
