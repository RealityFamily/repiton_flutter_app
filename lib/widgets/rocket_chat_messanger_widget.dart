import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repiton/core/network/rocket_chat/rest_api_rocket_chat.dart';
import 'package:repiton/model/rocket_chat_message.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/rocket_chat_messages.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/user.dart';
import 'package:rocket_chat_connector_flutter/web_socket/notification.dart' as rocket_notification;
import 'package:rocket_chat_connector_flutter/web_socket/web_socket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RocketChatMessangerWidget extends StatefulWidget {
  final String webSocketUrl = "wss://rocketchat.repiton.dev.realityfamily.ru:1043/websocket";
  final String channelName;
  final RocketChatRestAPI api;

  const RocketChatMessangerWidget({
    required this.api,
    required this.channelName,
    Key? key,
  }) : super(key: key);

  @override
  State<RocketChatMessangerWidget> createState() => _RocketChatMessangerWidgetState();
}

class _RocketChatMessangerWidgetState extends State<RocketChatMessangerWidget> {
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel? webSocketChannel;
  WebSocketService webSocketService = WebSocketService();
  User? user;

  final ScrollController _listViewScrollController = ScrollController();

  void getMessageFromSocket(dynamic event) {
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
    Provider.of<RocketChatMessages>(
      context,
      listen: false,
    ).addMessage(
      RocketChatMessage(
        id: notification.fields!.args![0].payload!.id!,
        sender: notification.fields!.args![0].payload!.sender!.username!,
        message: notification.fields!.args![0].payload!.message!.msg!,
        sendTime: notification.fields!.args![0].ts!,
      ),
    );
    _listViewScrollController.animateTo(
      _listViewScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    user = widget.api.authentication!.data!.me;
    webSocketChannel = webSocketService.connectToWebSocket(widget.webSocketUrl, widget.api.authentication!);
    webSocketService.streamNotifyUserSubscribe(webSocketChannel!, user!);

    webSocketChannel!.stream.listen(getMessageFromSocket);

    webSocketChannel!.stream.handleError((error) {
      throw error;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: (MediaQuery.of(context).size.height - 340 > 110 ? MediaQuery.of(context).size.height - 340 : 110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
              future: Provider.of<RocketChatMessages>(
                context,
                listen: false,
              ).fetchAndSetMessages(
                widget.api,
                widget.channelName,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  String userName = Provider.of<AuthProvider>(context, listen: false).userName;
                  return Consumer<RocketChatMessages>(
                    builder: (context, messages, _) => ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      reverse: true,
                      controller: _listViewScrollController,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: userName == messages.messages[index].sender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 4 * 3,
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(8),
                                  topRight: const Radius.circular(8),
                                  bottomLeft: userName == messages.messages[index].sender
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                  bottomRight: userName != messages.messages[index].sender
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                )),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  EmojiParser().emojify(messages.messages[index].message),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  softWrap: true,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  DateFormat("HH:mm").format(messages.messages[index].sendTime),
                                  style: const TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: messages.messages.length,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              padding: EdgeInsets.zero,
            ),
            Expanded(
              child: Form(
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: 'Сообщение...'),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<RocketChatMessages>(
                    context,
                    listen: false,
                  ).addMessage(
                    RocketChatMessage(
                      id: "",
                      sender: Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).userName,
                      message: _controller.text,
                      sendTime: DateTime.now(),
                    ),
                  );
                  webSocketService.sendMessageOnChannel(
                    _controller.text,
                    webSocketChannel!,
                    Channel(
                      id: widget.channelName,
                    ),
                  );
                  _listViewScrollController.animateTo(
                    _listViewScrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  _controller.clear();
                }
              },
              icon: const Icon(Icons.send),
              padding: EdgeInsets.zero,
            )
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    webSocketChannel!.sink.close();
    super.dispose();
  }
}
