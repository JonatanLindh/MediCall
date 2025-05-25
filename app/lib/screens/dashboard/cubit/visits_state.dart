part of 'visits_cubit.dart';

sealed class VisitsState extends Equatable {
  const VisitsState();
}

final class VisitsInitial extends VisitsState {
  const VisitsInitial();
  @override
  List<Object?> get props => [];
}

final class VisitsLoading extends VisitsState {
  const VisitsLoading();
  @override
  List<Object?> get props => [];
}

final class VisitsLoaded extends VisitsState {
  const VisitsLoaded(this.visits);
  final List<Visit> visits;

  @override
  List<Object?> get props => [visits];
}
