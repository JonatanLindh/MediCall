abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  SubmitFeedback(this.message);
  final String message;
}
