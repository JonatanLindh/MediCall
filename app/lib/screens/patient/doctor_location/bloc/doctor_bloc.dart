import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicall/repositories/doctor/doctor_repository.dart';
import 'package:medicall/repositories/geo/geo.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc({
    required this.geoRepository,
  }) : super(DoctorLoading()) {
    on<DoctorLocationSubscribeEvent>(_onLocationSubscription);
  }

  final GeoRepository geoRepository;
  String? doctorId;

  Future<void> _onLocationSubscription(
    DoctorLocationSubscribeEvent event,
    Emitter<DoctorState> emit,
  ) async {
    if (doctorId == null) return;

    await emit.forEach<StrippedPosition>(
      doctorLocationStream(doctorId: doctorId!),
      onData: DoctorAvailable.new,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return DoctorError(error.toString());
      },
    );
  }

  Stream<StrippedPosition> doctorLocationStream({
    required String doctorId,
  }) async* {
    while (true) {
      final pos = await geoRepository.getDoctorPosition(doctorId);

      if (pos != null) {
        yield StrippedPosition(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      }

      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }
}
