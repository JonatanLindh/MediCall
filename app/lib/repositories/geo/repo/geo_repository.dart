import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeoRepository {
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
    Duration timeInterval = const Duration(seconds: 10),
  }) async* {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      yield* Stream.error('Location permission denied or service disabled.');
      return;
    }

    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );

    yield* Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}
