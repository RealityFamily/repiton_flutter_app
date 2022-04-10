import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/core/network/rest_api_rocket_chat.dart';
import 'package:repiton/provider/rocket_chat_messages.dart';
import 'package:repiton/widgets/rocket_chat_messanger_widget.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';

class RocketChatScreen extends StatefulWidget {
  late final RocketChatRestAPI api = RocketChatRestAPI();

  RocketChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RocketChatScreen> createState() => _RocketChatScreenState();
}

class _RocketChatScreenState extends State<RocketChatScreen> {
  Channel? _channel;

  Future<List<Channel>> getChannels() async {
    if (widget.api.authentication == null) {
      await widget.api.auth(
        username: "leonis13579@gmail.com",
        password: "1357924680",
      );
    }

    List<Channel> result = await widget.api.getChannels();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Channel>>(
        future: getChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DropdownButton<Channel>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        value: _channel,
                        items: snapshot.data!.map((channel) {
                          return DropdownMenuItem<Channel>(
                            child: ChannelNameWidget(name: channel.name!),
                            value: channel,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _channel = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        String? newChannelName = await showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController _nameController = TextEditingController();

                            return AlertDialog(
                              title: const Text("Добавить новый канал"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      "Введите название текстового канала, который будет высвечиваться у Вас и у ученика."),
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: "Название канала",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("ОТМЕНА"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context, _nameController.text.isNotEmpty ? _nameController.text : null);
                                  },
                                  child: const Text("ОК"),
                                ),
                              ],
                            );
                          },
                        );

                        if (newChannelName == null) {
                          return;
                        }
                        Channel? newChannel = await widget.api.addChannel(newChannelName);

                        if (newChannel == null) {
                          return;
                        }
                        setState(() {
                          _channel = newChannel;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                    if (_channel != null &&
                        _channel!.name != null &&
                        _channel!.name! != "general" &&
                        _channel!.name! != "someShit")
                      IconButton(
                        onPressed: () async {
                          bool confirm = (await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Подтвердите удаление текстового канала",
                                  ),
                                  content: const Text(
                                    "При удалении текстового канала вы утратите доступ ко всем сообщениям, файлам и другим материалам, хранящимся в канале.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text("ОТМЕНА"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("УДАЛИТЬ"),
                                    ),
                                  ],
                                ),
                              )) ??
                              false;

                          if (!confirm) {
                            return;
                          }

                          bool result = await widget.api.deleteChannel(_channel!);
                          if (!result) {
                            return;
                          }
                          setState(() {
                            _channel = null;
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
                if (_channel != null)
                  ChangeNotifierProvider(
                    create: (context) => RocketChatMessages(),
                    child: RocketChatMessangerWidget(
                      api: widget.api,
                      channelName: _channel!.id!,
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ChannelNameWidget extends StatelessWidget {
  const ChannelNameWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    String? channelNameText;

    if (name == "general") {
      channelNameText = "Общий";
    } else if (name == "someShit") {
      channelNameText = "Домашнее задание";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(channelNameText ?? name),
        Container(
          width: Random().nextBool() ? 10 : 0, // TODO: Need to check new messages
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
