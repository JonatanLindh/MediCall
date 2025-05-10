import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<SubmitFeedback>((event, emit) async {
      emit(FeedbackSubmitting());
      await Future.delayed(const Duration(seconds: 1));
      emit(FeedbackSubmitted());
    });
  }
}
