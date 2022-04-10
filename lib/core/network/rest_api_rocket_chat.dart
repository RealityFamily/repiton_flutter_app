import 'package:repiton/model/rocket_chat_message.dart';
import 'package:rocket_chat_connector_flutter/models/authentication.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/channel_messages.dart';
import 'package:rocket_chat_connector_flutter/models/filters/channel_history_filter.dart';
import 'package:rocket_chat_connector_flutter/models/message.dart';
import 'package:rocket_chat_connector_flutter/models/new/channel_new.dart';
import 'package:rocket_chat_connector_flutter/services/authentication_service.dart';
import 'package:rocket_chat_connector_flutter/services/channel_service.dart';
import 'package:rocket_chat_connector_flutter/services/http_service.dart'
    as rocket_http_service;

class RocketChatRestAPI {
  final String serverUrl = "https://rocketchat.repiton.dev.realityfamily.ru/";
  Authentication? authentication;
  late final rocket_http_service.HttpService _rocketHttpService;

  Future<void> auth({
    required String username,
    required String password,
  }) async {
    _rocketHttpService = rocket_http_service.HttpService(Uri.parse(serverUrl));
    final AuthenticationService authenticationService =
        AuthenticationService(_rocketHttpService);
    authentication = await authenticationService.login(username, password);
  }

  Future<Channel?> addChannel(String newName) async {
    ChannelService channelService = ChannelService(_rocketHttpService);
    return (await channelService.create(
      ChannelNew(name: newName),
      authentication!,
    ))
        .channel;
  }

  Future<bool> deleteChannel(Channel channel) async {
    ChannelService channelService = ChannelService(_rocketHttpService);
    return await channelService.delete(
      channel,
      authentication!,
    );
  }

  Future<List<Channel>> getChannels() async {
    ChannelService channelService = ChannelService(_rocketHttpService);
    return await channelService.getChannels(authentication!);
  }

  Future<List<RocketChatMessage>> getChannelMessages({
    required String channelID,
    required int messageCount,
  }) async {
    ChannelService channelService = ChannelService(_rocketHttpService);
    Channel channel = Channel(id: channelID);
    ChannelHistoryFilter channelHistoryFilter =
        ChannelHistoryFilter(channel, count: messageCount);

    List<Message>? response =
        (await channelService.history(channelHistoryFilter, authentication!))
            .messages;
    List<RocketChatMessage> result = [];

    if (response == null) {
      return result;
    }
    for (var message in response) {
      if (message.ts == null ||
          message.msg == null ||
          message.id == null ||
          message.user == null ||
          message.user!.username == null ||
          message.msg!.isEmpty ||
          message.msg! == message.user!.username!) {
        continue;
      }
      result.add(
        RocketChatMessage(
            id: message.id!,
            sender: message.user!.username!,
            message: message.msg!,
            sendTime: message.ts!),
      );
    }

    return result;
  }
}
