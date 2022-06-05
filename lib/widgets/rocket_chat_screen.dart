import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/rocket_chat_messanger_widget.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';

class RocketChatScreen extends ConsumerWidget {
  const RocketChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(RootProvider.getRocketChatMessagesProvider(refresh: true));

    return FutureBuilder(
        future: provider.fetchAndSetChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
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
                        value: provider.choosedChannel,
                        items: provider.channels.map((channel) {
                          return DropdownMenuItem<Channel>(
                            child: ChannelNameWidget(name: channel.name!),
                            value: channel,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          provider.setChannel(newValue);
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
                        RootProvider.getRocketChatMessages().addChannel(newChannelName);
                      },
                      icon: const Icon(Icons.add),
                    ),
                    if (provider.choosedChannel != null &&
                        provider.choosedChannel!.name != null &&
                        provider.choosedChannel!.name! != "general" &&
                        provider.choosedChannel!.name! != "someShit")
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
                          await provider.deleteChannel();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                  ],
                ),
                if (provider.choosedChannel != null) const RocketChatMessangerWidget(),
              ],
            );
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
