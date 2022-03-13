import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:repiton/rest_api_rocket_chat.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/room.dart';
import 'package:rocket_chat_connector_flutter/models/user.dart';
import 'package:rocket_chat_connector_flutter/web_socket/notification.dart'
    as rocket_notification;
import 'package:rocket_chat_connector_flutter/web_socket/web_socket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RocketChatScreen extends StatefulWidget {
  final title = 'Rocket Chat WebSocket Demo';

  final String serverUrl = "https://rocketchat.repiton.dev.realityfamily.ru/";
  final String webSocketUrl =
      "wss://rocketchat.repiton.dev.realityfamily.ru:3000/";
  final Channel channel = Channel(id: "GENERAL");
  final Room room = Room(id: "GENERAL");
  late final RocketChatRestAPI api = RocketChatRestAPI();

  RocketChatScreen({Key? key}) : super(key: key);

  @override
  State<RocketChatScreen> createState() => _RocketChatScreenState();
}

class _RocketChatScreenState extends State<RocketChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel webSocketChannel;
  WebSocketService webSocketService = WebSocketService();
  User? user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: widget.api.auth(
          username: "leonis13579@gmail.com",
          password: "1357924680",
        ),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            user = widget.api.authentication.data!.me;
            webSocketChannel = webSocketService.connectToWebSocket(
                widget.webSocketUrl, widget.api.authentication);
            webSocketService.streamNotifyUserSubscribe(webSocketChannel, user!);
            return _getScaffold();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Scaffold _getScaffold() {
    webSocketChannel.stream.handleError((error) => throw error);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: webSocketChannel.stream,
              builder: (context, snapshot) {
                debugPrint(snapshot.data.toString());
                rocket_notification.Notification? notification =
                    snapshot.hasData
                        ? rocket_notification.Notification.fromMap(
                            jsonDecode(snapshot.data as String))
                        : null;
                webSocketService.streamNotifyUserSubscribe(
                    webSocketChannel, user!);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child:
                      Text(notification != null ? notification.toString() : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      webSocketService.sendMessageOnChannel(
          _controller.text, webSocketChannel, widget.channel);
      // webSocketService.sendMessageOnRoom(
      //     _controller.text, webSocketChannel, widget.room);
    }
  }

  @override
  void dispose() {
    webSocketChannel.sink.close();
    super.dispose();
  }
}
