import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/patient/profile/health_detail/bloc/health_detail_event.dart';
import 'package:medicall/screens/patient/profile/health_detail/bloc/health_detail_state.dart'; 


class HealthDetailBloc extends Bloc<HealthDetailEvent, HealthDetailState> {
  HealthDetailBloc() : super(HealthDetailInitial()) {
    on<LoadHealthDetailData>((event, emit) {
      emit(HealthDetailLoaded('Mock Data'));
    });
  }
}
