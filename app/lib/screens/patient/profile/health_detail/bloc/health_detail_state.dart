abstract class HealthDetailState {}

class HealthDetailInitial extends HealthDetailState {}

class HealthDetailLoaded extends HealthDetailState {
  final String info;
  HealthDetailLoaded(this.info);
}
