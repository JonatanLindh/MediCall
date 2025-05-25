part of 'call_bloc.dart';

@immutable
sealed class CallEvent {}

class CallStartEvent extends CallEvent {
  CallStartEvent(this.roomNameToConnect);
  final String roomNameToConnect;
}

class CallCancelEvent extends CallEvent {}

class _UpdateParticipantsUIEvent extends CallEvent {
  _UpdateParticipantsUIEvent();
}

class _ParticipantConnectedEvent extends CallEvent {
  _ParticipantConnectedEvent();
}

class _ParticipantDisconnectedEvent extends CallEvent {
  _ParticipantDisconnectedEvent(this.e);
  final ParticipantDisconnectedEvent e;
}
