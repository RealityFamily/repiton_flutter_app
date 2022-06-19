import 'package:json_annotation/json_annotation.dart';

part 'rocket_chat_dto.g.dart';

@JsonSerializable()
class RocketChatDTO {
  String id;
  String channelName;

  RocketChatDTO({
    required this.id,
    required this.channelName,
  });

  factory RocketChatDTO.fromJson(Map<String, dynamic> json) => _$RocketChatDTOFromJson(json);
  Map<String, dynamic> toJson() => _$RocketChatDTOToJson(this);
}
