part of 'call_bloc.dart';

@immutable
sealed class CallState {}

final class CallInitial extends CallState {}

final class CallCalling extends CallState {}

final class CallAnswered extends CallState {
  CallAnswered(this.localParticipant, this.remoteParticipants);
  final List<RemoteParticipant> remoteParticipants;
  final LocalParticipant localParticipant;
}

final class CallError extends CallState {
  CallError(this.msg);
  final String msg;
}
