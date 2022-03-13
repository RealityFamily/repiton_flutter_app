import 'package:rocket_chat_connector_flutter/models/authentication.dart';
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/channel_messages.dart';
import 'package:rocket_chat_connector_flutter/models/filters/channel_history_filter.dart';
import 'package:rocket_chat_connector_flutter/models/new/message_new.dart';
import 'package:rocket_chat_connector_flutter/models/response/message_new_response.dart';
import 'package:rocket_chat_connector_flutter/models/room.dart';
import 'package:rocket_chat_connector_flutter/services/authentication_service.dart';
import 'package:rocket_chat_connector_flutter/services/channel_service.dart';
import 'package:rocket_chat_connector_flutter/services/http_service.dart'
    as rocket_http_service;
import 'package:rocket_chat_connector_flutter/services/message_service.dart';
import 'package:rocket_chat_connector_flutter/services/room_service.dart';

class RocketChatRestAPI {
  final String serverUrl = "https://rocketchat.repiton.dev.realityfamily.ru/";
  late final Authentication authentication;
  late final rocket_http_service.HttpService rocketHttpService;

  Future<void> auth({
    required String username,
    required String password,
  }) async {
    rocketHttpService = rocket_http_service.HttpService(Uri.parse(serverUrl));
    final AuthenticationService authenticationService =
        AuthenticationService(rocketHttpService);
    authentication = await authenticationService.login(username, password);
  }

  Future<List<Room>> getRooms() async {
    RoomService roomService = RoomService(rocketHttpService);
    return await roomService.getRooms(authentication);
  }

  Future<ChannelMessages> getChannelMessages({
    required String channelID,
  }) async {
    ChannelService channelService = ChannelService(rocketHttpService);
    Channel channel = Channel(id: channelID);
    ChannelHistoryFilter channelHistoryFilter =
        ChannelHistoryFilter(channel, count: 50);
    return await channelService.history(channelHistoryFilter, authentication);
  }

  Future<MessageNewResponse> sendMessage({
    required String channelID,
    required String message,
  }) async {
    MessageService messageService = MessageService(rocketHttpService);
    Channel channel = Channel(id: channelID);
    MessageNew messageNew = MessageNew(
      roomId: channel.id,
      text: message,
    );
    return await messageService.postMessage(
      messageNew,
      authentication,
    );
  }
}
