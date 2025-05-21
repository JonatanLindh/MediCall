abstract class HealthDetailState {}

class HealthDetailInitial extends HealthDetailState {}

class HealthDetailLoaded extends HealthDetailState {
  HealthDetailLoaded(this.info);
  final String info;
}
