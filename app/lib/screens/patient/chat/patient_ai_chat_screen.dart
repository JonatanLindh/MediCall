import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../app/shared_chat/bloc/chat_bloc.dart';
import '../../../../app/shared_chat/bloc/chat_event.dart';
import '../../../../app/shared_chat/bloc/chat_state.dart';
import '../../../../models/message_model.dart';

class PatientAIChatScreen extends StatefulWidget {
  const PatientAIChatScreen({super.key});

  @override
  State<PatientAIChatScreen> createState() => _PatientAIChatScreenState();
}

class _PatientAIChatScreenState extends State<PatientAIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts.setLanguage('en-US');
    _flutterTts.setPitch(1.0);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talk to Caregiver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear Chat',
            onPressed: () {
              context.read<ChatBloc>().clearMessages();
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final List<ChatMessage> messages =
              state is ChatUpdated ? state.messages as List<ChatMessage> : [];

          // Speak last doctor message
          if (state is ChatUpdated && messages.isNotEmpty) {
            final last = messages.last;
            if (last.sender == 'doctor') {
              _flutterTts.speak(last.text);
            }
          }

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (_, index) {
                          final ChatMessage msg = messages[index];
                          return ListTile(
                            title: Text(
                              '${msg.sender} • ${msg.timestamp.hour}:${msg.timestamp.minute}',
                            ),
                            subtitle: Text(msg.text),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                      tooltip: 'Tap to speak',
                      onPressed: _listen,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type or speak your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final messageText = _controller.text.trim();
                        if (messageText.isNotEmpty) {
                          context.read<ChatBloc>().add(
                                SendChatMessage('patient', messageText),
                              );
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
