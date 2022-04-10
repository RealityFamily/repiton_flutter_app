class RocketChatMessage {
  late String id;
  late String sender;
  late String message;
  late DateTime sendTime;

  RocketChatMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.sendTime,
  });

  RocketChatMessage.empty() {
    id = "";
    sender = "";
    message = "";
    sendTime = DateTime.now();
  }
}
