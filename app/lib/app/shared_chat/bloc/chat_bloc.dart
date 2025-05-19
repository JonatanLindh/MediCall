import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_event.dart';
import 'chat_state.dart';
import '../../../models/message_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages = [];

  ChatBloc() : super(ChatInitial()) {
    _loadMessages();

    on<SendChatMessage>((event, emit) async {
      final message = ChatMessage(
        sender: event.sender,
        text: event.text,
        timestamp: DateTime.now(),
      );
      _messages.add(message);
      emit(ChatUpdated(List.from(_messages)));
      await _saveMessages();
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('chat_messages') ?? [];

    _messages.clear();
    for (final jsonStr in data) {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      _messages.add(ChatMessage(
        sender: map['sender'] as String,
        text: map['text'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      ));
    }
    emit(ChatUpdated(List.from(_messages)));
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _messages.map((msg) {
      return json.encode({
        'sender': msg.sender,
        'text': msg.text,
        'timestamp': msg.timestamp.toIso8601String(),
      });
    }).toList();
    await prefs.setStringList('chat_messages', data);
  }

  Future<void> clearMessages() async {
    _messages.clear();
    emit(ChatUpdated([]));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
  }
}
