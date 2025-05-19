abstract class ChatEvent {}

class SendChatMessage extends ChatEvent {
  final String sender;
  final String text;

  SendChatMessage(this.sender, this.text);
}
