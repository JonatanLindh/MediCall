import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicall/repositories/geo/geo.dart';

part 'doctor_location_event.dart';
part 'doctor_location_state.dart';

class DoctorLocationBloc
    extends Bloc<DoctorLocationEvent, DoctorLocationState> {
  DoctorLocationBloc({
    required this.geoRepository,
  }) : super(DoctorLocationLoading()) {
    on<DoctorLocationSubscribe>(_onSubscription);
  }

  final GeoRepository geoRepository;

  Future<void> _onSubscription(
    DoctorLocationSubscribe event,
    Emitter<DoctorLocationState> emit,
  ) async {
    await emit.forEach<StrippedPosition>(
      doctorLocationStream(doctorId: event.doctorId),
      onData: DoctorLocationAvailable.new,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return DoctorLocationError(error.toString());
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
