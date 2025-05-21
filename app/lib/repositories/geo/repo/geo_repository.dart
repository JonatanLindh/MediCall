import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';

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

  Stream<Position> get getPositionStream async* {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      yield* Stream.error('Location permission denied or service disabled.');
      return;
    }

    yield* Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }

  Future<void> uploadPosition(String doctorId, Position position) async {
    await http.patch(
      Uri.parse('$apiUrl/doctors/$doctorId/location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(StrippedPosition.fromPosition(position).toJson()),
    );
  }

  Future<StrippedPosition?> getDoctorPosition(String doctorId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/doctors/$doctorId/location'),
      headers: {},
    );

    if (response.statusCode == 200) {
      return StrippedPosition.fromJson(response.body);
    } else {
      return null;
    }
  }
}

class StrippedPosition {
  StrippedPosition({
    required this.latitude,
    required this.longitude,
  });

  factory StrippedPosition.fromJson(String source) {
    final data = jsonDecode(source) as Map<String, dynamic>;
    return StrippedPosition(
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
    );
  }

  factory StrippedPosition.fromPosition(Position position) {
    return StrippedPosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

LocationSettings get locationSettings {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 3),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: 'Running in Background',
          enableWakeLock: true,
        ),
      );
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
      );
    // ignore: no_default_cases
    default:
      if (kIsWeb) {
        return WebSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          maximumAge: const Duration(minutes: 5),
        );
      }
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
  }
}
