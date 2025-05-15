abstract class FeedbackEvent {}

class SubmitFeedback extends FeedbackEvent {
  final String message;
  SubmitFeedback(this.message);
}
