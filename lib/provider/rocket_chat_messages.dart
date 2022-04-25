import 'package:flutter/foundation.dart';
import 'package:repiton/core/network/rocket_chat/rest_api_rocket_chat.dart';
import 'package:repiton/model/rocket_chat_message.dart';

class RocketChatMessages with ChangeNotifier {
  List<RocketChatMessage> _messages = [];

  List<RocketChatMessage> get messages => [..._messages];

  void addMessage(RocketChatMessage message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  Future<void> fetchAndSetMessages(
    RocketChatRestAPI api,
    String channelId,
  ) async {
    _messages = await api.getChannelMessages(
        channelID: channelId, messageCount: _messages.length + 15);
    notifyListeners();
  }
}
