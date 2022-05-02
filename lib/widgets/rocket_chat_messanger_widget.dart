import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/rocket_chat_message.dart';
import 'package:repiton/provider/root_provider.dart';

class RocketChatMessangerWidget extends StatefulWidget {
  const RocketChatMessangerWidget({Key? key}) : super(key: key);

  @override
  State<RocketChatMessangerWidget> createState() => _RocketChatMessangerWidgetState();
}

class _RocketChatMessangerWidgetState extends State<RocketChatMessangerWidget> {
  final TextEditingController _controller = TextEditingController();

  final ScrollController _listViewScrollController = ScrollController();

  void moveToNewMessage() => _listViewScrollController.animateTo(
        _listViewScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: (MediaQuery.of(context).size.height - 340 > 110
                        ? MediaQuery.of(context).size.height - 340
                        : 110),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FutureBuilder(
                        future: RootProvider.getRocketChatMessages().fetchAndSetMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            String userName = RootProvider.getAuth().userName;
                            return Consumer(
                              builder: (context, ref, _) {
                                final messages = ref.watch(RootProvider.getRocketChatMessagesProvider());

                                return ListView.separated(
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
                                );
                              },
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
                            RootProvider.getRocketChatMessages().sendMessage(
                              RocketChatMessage(
                                id: "",
                                sender: RootProvider.getAuth().userName,
                                message: _controller.text,
                                sendTime: DateTime.now(),
                              ),
                            );
                            moveToNewMessage();
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
      },
    );
  }

  @override
  void dispose() {
    RootProvider.getRocketChatMessages().disposeWebSocket();
    super.dispose();
  }
}
