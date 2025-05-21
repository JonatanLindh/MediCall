import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/patient/feedback/bloc/feedback_bloc.dart';
import 'package:medicall/screens/patient/feedback/bloc/feedback_event.dart';
import 'package:medicall/screens/patient/feedback/bloc/feedback_state.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Feedback')),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: _FeedbackForm(),
        ),
      ),
    );
  }
}

class _FeedbackForm extends StatefulWidget {
  const _FeedbackForm();

  @override
  State<_FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<_FeedbackForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks for your feedback!')),
          );
          _controller.clear();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Text(
            'We’d love to hear from you',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ), 
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Type your message here…',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, state) {
              final isLoading = state is FeedbackSubmitting;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final message = _controller.text.trim();
                        if (message.isNotEmpty) {
                          context.read<FeedbackBloc>().add(
                                SubmitFeedback(message),
                              );
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              );
            },
          ),
        ],
      ),
    );
  }
}
