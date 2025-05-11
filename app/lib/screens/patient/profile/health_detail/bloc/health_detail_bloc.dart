import 'package:flutter_bloc/flutter_bloc.dart';
import 'health_detail_event.dart';
import 'health_detail_state.dart'; 


class HealthDetailBloc extends Bloc<HealthDetailEvent, HealthDetailState> {
  HealthDetailBloc() : super(HealthDetailInitial()) {
    on<LoadHealthDetailData>((event, emit) {
      emit(HealthDetailLoaded("Mock Data"));
    });
  }
}
