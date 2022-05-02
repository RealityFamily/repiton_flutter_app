import 'dart:convert';

import 'package:repiton/model/rocket_chat_message.dart';
import 'package:rocket_chat_connector_flutter/models/authentication.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/user.dart';
import 'package:rocket_chat_connector_flutter/web_socket/web_socket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rocket_chat_connector_flutter/web_socket/notification.dart' as rocket_notification;

class WebSocketRocketChat {
  final String _webSocketUrl = "wss://rocketchat.repiton.dev.realityfamily.ru:1043/websocket";

  WebSocketChannel? webSocketChannel;
  WebSocketService webSocketService = WebSocketService();
  User? user;

  void getMessageFromSocket(dynamic event, Function(RocketChatMessage) addMessage) {
    rocket_notification.Notification? notification =
        event is String ? rocket_notification.Notification.fromMap(jsonDecode(event)) : null;
    webSocketService.streamNotifyUserSubscribe(webSocketChannel!, user!);

    if (notification == null) {
      return;
    }
    if (notification.fields == null) {
      return;
    }
    if (notification.fields!.args == null) {
      return;
    }
    if (notification.fields!.args!.isEmpty) {
      return;
    }
    if (notification.fields!.args![0].ts == null) {
      return;
    }
    if (notification.fields!.args![0].payload == null) {
      return;
    }
    if (notification.fields!.args![0].payload!.id == null) {
      return;
    }
    if (notification.fields!.args![0].payload!.message == null) {
      return;
    }
    if (notification.fields!.args![0].payload!.message!.msg == null) {
      return;
    }
    if (notification.fields!.args![0].payload!.sender == null) {
      return;
    }
    if (notification.fields!.args![0].payload!.sender!.username == null) {
      return;
    }

    addMessage(RocketChatMessage(
      id: notification.fields!.args![0].payload!.id!,
      sender: notification.fields!.args![0].payload!.sender!.username!,
      message: notification.fields!.args![0].payload!.message!.msg!,
      sendTime: notification.fields!.args![0].ts!,
    ));
  }

  WebSocketRocketChat(Authentication _authentication, Function(RocketChatMessage) addMessage) {
    user = _authentication.data!.me;
    webSocketChannel = webSocketService.connectToWebSocket(_webSocketUrl, _authentication);
    webSocketService.streamNotifyUserSubscribe(webSocketChannel!, user!);

    webSocketChannel!.stream.listen((event) => getMessageFromSocket(event, addMessage));

    webSocketChannel!.stream.handleError((error) {
      throw error;
    });
  }

  void sendMeaasgeToChannel(String message, Channel channel) {
    webSocketService.sendMessageOnChannel(message, webSocketChannel!, channel);
  }

  void dispose() {
    webSocketChannel!.sink.close();
  }
}
