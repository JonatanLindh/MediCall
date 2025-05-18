import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/screens/patient/feedback/bloc/feedback_event.dart';
import 'package:medicall/screens/patient/feedback/bloc/feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<SubmitFeedback>((event, emit) async {
      emit(FeedbackSubmitting());
      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(seconds: 1));
      emit(FeedbackSubmitted());
    });
  }
}
