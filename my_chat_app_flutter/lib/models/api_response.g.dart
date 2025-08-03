// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'message': instance.message, 'user': instance.user};

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{'message': instance.message, 'user': instance.user};

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      token: json['token'] as String,
      user: StreamUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user};

StreamUser _$StreamUserFromJson(Map<String, dynamic> json) => StreamUser(
  id: json['id'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$StreamUserToJson(StreamUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

CreateChannelResponse _$CreateChannelResponseFromJson(
  Map<String, dynamic> json,
) => CreateChannelResponse(
  success: json['success'] as bool,
  streamCid: json['streamCid'] as String?,
  dbId: (json['dbId'] as num?)?.toInt(),
  channelId: json['channelId'] as String?,
  message: json['message'] as String,
  action: json['action'] as String?,
);

Map<String, dynamic> _$CreateChannelResponseToJson(
  CreateChannelResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'streamCid': instance.streamCid,
  'dbId': instance.dbId,
  'channelId': instance.channelId,
  'message': instance.message,
  'action': instance.action,
};

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(error: json['error'] as String);

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{'error': instance.error};
