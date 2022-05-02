import 'package:flutter/foundation.dart';
import 'package:repiton/core/network/rocket_chat/rest_api_rocket_chat.dart';
import 'package:repiton/core/network/rocket_chat/web_socket_rocket_chat.dart';
import 'package:repiton/model/rocket_chat_message.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';

class RocketChatMessagesProvider with ChangeNotifier {
  late final RocketChatRestAPI _api;
  WebSocketRocketChat? _webSocketApi;

  RocketChatMessagesProvider() {
    _api = RocketChatRestAPI();
  }

  Future<void> checkAuth() async {
    if (_api.authentication == null) {
      await _api.auth(
        username: "leonis13579@gmail.com",
        password: "1357924680",
      );
    }
  }

  List<Channel> channels = [];
  Channel? choosedChannel;

  Future<void> fetchAndSetChannels() async {
    await checkAuth();

    channels = await _api.getChannels();
    notifyListeners();
  }

  Future<void> addChannel(String channelName) async {
    await checkAuth();

    final newChannel = await _api.addChannel(channelName);
    if (newChannel != null) {
      channels.add(newChannel);
      choosedChannel = newChannel;
      notifyListeners();
    }
  }

  Future<void> deleteChannel() async {
    await checkAuth();

    if (choosedChannel == null) return;

    final isDeleted = await _api.deleteChannel(choosedChannel!);
    if (isDeleted) {
      channels.remove(choosedChannel);
      choosedChannel = null;
      notifyListeners();
    }
  }

  void setChannel(Channel? newChannel) {
    choosedChannel = newChannel;
    notifyListeners();
  }

  List<RocketChatMessage> _messages = [];

  List<RocketChatMessage> get messages => [..._messages];

  void addMessage(RocketChatMessage message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  Future<void> fetchAndSetMessages() async {
    await checkAuth();

    if (choosedChannel == null) return;

    _messages = await _api.getChannelMessages(channelID: choosedChannel!.id!, messageCount: _messages.length + 15);
    notifyListeners();
  }

  Future<void> initWebSocket(Function() moveToNewMessage) async {
    await checkAuth();

    _webSocketApi = WebSocketRocketChat(_api.authentication!, (newMessage) {
      addMessage(newMessage);
      moveToNewMessage();
    });
  }

  void sendMessage(RocketChatMessage message) {
    if (message.message.isNotEmpty) {
      _messages.insert(0, message);
      if (_webSocketApi != null && choosedChannel != null) {
        _webSocketApi!.sendMeaasgeToChannel(message.message, choosedChannel!);
        notifyListeners();
      }
    }
  }

  void disposeWebSocket() {
    if (_webSocketApi == null) return;

    _webSocketApi!.dispose();
    _webSocketApi = null;
  }
}
