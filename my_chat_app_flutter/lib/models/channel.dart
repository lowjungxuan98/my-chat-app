import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable()
class Channel {
  final int id;
  final String channelId;
  final String type;
  final String name;
  final List<ChannelMember>? members;

  Channel({
    required this.id,
    required this.channelId,
    required this.type,
    required this.name,
    this.members,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  Channel copyWith({
    int? id,
    String? channelId,
    String? type,
    String? name,
    List<ChannelMember>? members,
  }) {
    return Channel(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      type: type ?? this.type,
      name: name ?? this.name,
      members: members ?? this.members,
    );
  }

  @override
  String toString() {
    return 'Channel{id: $id, channelId: $channelId, type: $type, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Channel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          channelId == other.channelId;

  @override
  int get hashCode => id.hashCode ^ channelId.hashCode;
}

@JsonSerializable()
class ChannelMember {
  final int id;
  final String channelId;
  final String userId;

  ChannelMember({
    required this.id,
    required this.channelId,
    required this.userId,
  });

  factory ChannelMember.fromJson(Map<String, dynamic> json) => 
      _$ChannelMemberFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelMemberToJson(this);

  @override
  String toString() {
    return 'ChannelMember{id: $id, channelId: $channelId, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelMember &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}