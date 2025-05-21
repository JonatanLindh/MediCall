part of 'geo_bloc.dart';

sealed class GeoState extends Equatable {
  const GeoState();

  @override
  List<Object> get props => [];
}

final class GeoInitial extends GeoState {}

final class GeoLoading extends GeoState {}

final class GeoGotPosition extends GeoState {
  const GeoGotPosition(this.position);

  final Position position;

  @override
  List<Object> get props => [position];
}

final class GeoError extends GeoState {
  const GeoError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
