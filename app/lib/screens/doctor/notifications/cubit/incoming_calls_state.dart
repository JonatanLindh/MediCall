part of 'incoming_calls_cubit.dart';

sealed class IncomingCallsState extends Equatable {
  const IncomingCallsState();
}

final class IncomingCallsInitial extends IncomingCallsState {
  const IncomingCallsInitial();
  @override
  List<Object?> get props => [];
}

final class IncomingCallsLoading extends IncomingCallsState {
  const IncomingCallsLoading();
  @override
  List<Object?> get props => [];
}

final class IncomingCallsLoaded extends IncomingCallsState {
  const IncomingCallsLoaded(this.incomingCalls);
  final List<String> incomingCalls;

  @override
  List<Object?> get props => [incomingCalls];
}
