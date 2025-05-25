import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:livekit_client/livekit_client.dart';
import 'package:medicall/contants/api.dart';
import 'package:meta/meta.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInitial()) {
    on<CallStartEvent>(onCallStartEvent);
    on<CallCancelEvent>(onCallCancelEvent);
    on<_UpdateParticipantsUIEvent>(onUpdateParticipantsUI);
    on<_ParticipantConnectedEvent>(onParticipantConnectedEvent);
    on<_ParticipantDisconnectedEvent>(onParticipantDisconnectedEvent);
  }

  CancelableOperation<void>? _callOperation;

  Room room = Room();
  EventsListener<RoomEvent>? _listener;

  Future<String?> getVideoToken() async {
    final response = await http.get(
      Uri.parse('$apiUrl/getvideotoken'),
      headers: {'Content-Type': 'application/json'},
    );
    print('$apiUrl/getvideotoken');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');
    }
    return null;
  }

  Future<void> call(String token) async {
    const roomOptions = RoomOptions(
      adaptiveStream: true,
      dynacast: true,
    );
    room = Room(roomOptions: roomOptions);

    await room.prepareConnection(
      callUrl,
      token,
    );

    await room.connect(
      callUrl,
      token,
      connectOptions: const ConnectOptions(),
    );
    if (room.localParticipant == null) {
      return;
    }

    try {
      await room.localParticipant!.setMicrophoneEnabled(true);
    } catch (e) {
      print('No mic found');
    }
    try {
      await room.localParticipant!.setCameraEnabled(true);
    } catch (e) {
      print('No camera found');
    }
  }

  Future<void> onCallStartEvent(
    CallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(CallCalling());

    _callOperation = CancelableOperation.fromFuture(() async {
      final token = await getVideoToken();
      if (token == null) {
        emit(CallError('No video token'));
        return;
      }

      await call(token);

      if (room.localParticipant == null) {
        await room.disconnect();
        emit(CallError('No local participant found'));
        return;
      }

      addListeners();

      emit(
        CallAnswered(
          room.localParticipant!,
          room.remoteParticipants.values.toList(),
        ),
      );
    }());

    await _callOperation!.valueOrCancellation();
  }

  Future<void> onCallCancelEvent(
    CallEvent event,
    Emitter<CallState> emit,
  ) async {
    await _callOperation?.cancel();
    await room.disconnect();
    await _listener?.dispose();

    emit(CallInitial());
  }

  void addListeners() {
    _listener = room.createListener();

    _listener!
      ..on<RoomEvent>((e) {
        print(room.localParticipant!.identity);
        print(e.runtimeType);
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        add(_ParticipantDisconnectedEvent(e));
      })
      ..on<ParticipantConnectedEvent>((e) {
        add(_ParticipantConnectedEvent());
      })
      ..on<ActiveSpeakersChangedEvent>((e) {})
      ..on<TrackPublishedEvent>((event) {
        print('UDHDH');
        print(event.publication.track.runtimeType);

        if (event.publication.track is AudioTrack) {
          final audioTrack = event.publication.track! as AudioTrack;
          audioTrack.start(); // Start playing the audio
        } else {
          add(_UpdateParticipantsUIEvent());
        }
      })
      ..on<TrackSubscribedEvent>((e) {
        add(_UpdateParticipantsUIEvent());
      });
  }

  void onUpdateParticipantsUI(
    CallEvent e,
    Emitter<CallState> emit,
  ) {
    emit(
      CallAnswered(
        room.localParticipant!,
        room.remoteParticipants.values.toList(),
      ),
    );
  }

  void onParticipantConnectedEvent(
    CallEvent e,
    Emitter<CallState> emit,
  ) {
    emit(
      CallAnswered(
        room.localParticipant!,
        room.remoteParticipants.values.toList(),
      ),
    );
  }

  void onParticipantDisconnectedEvent(
    CallEvent e,
    Emitter<CallState> emit,
  ) {
    emit(
      CallAnswered(
        room.localParticipant!,
        room.remoteParticipants.values.toList(),
      ),
    );
  }
}
