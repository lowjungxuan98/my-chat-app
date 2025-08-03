// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
  id: (json['id'] as num).toInt(),
  channelId: json['channelId'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMember.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
  'id': instance.id,
  'channelId': instance.channelId,
  'type': instance.type,
  'name': instance.name,
  'members': instance.members,
};

ChannelMember _$ChannelMemberFromJson(Map<String, dynamic> json) =>
    ChannelMember(
      id: (json['id'] as num).toInt(),
      channelId: json['channelId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$ChannelMemberToJson(ChannelMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelId': instance.channelId,
      'userId': instance.userId,
    };
