import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicall/repositories/geo/repo/geo_repository.dart';

part 'geo_event.dart';
part 'geo_state.dart';

class GeoBloc extends Bloc<GeoEvent, GeoState> {
  GeoBloc({
    required this.geoRepository,
  }) : super(GeoInitial()) {
    on<GeoSubscriptionRequested>(_onSubscriptionRequested);
  }

  final GeoRepository geoRepository;

  Future<void> _onSubscriptionRequested(
    GeoSubscriptionRequested event,
    Emitter<GeoState> emit,
  ) async {
    await emit.forEach(
      geoRepository.getPositionStream,
      onData: (data) {
        return GeoGotPosition(data);
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return GeoError(error.toString());
      },
    );
  }
}
