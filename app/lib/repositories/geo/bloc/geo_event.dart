part of 'geo_bloc.dart';

sealed class GeoEvent {
  const GeoEvent();
}

final class GeoSubscriptionRequested extends GeoEvent {}
