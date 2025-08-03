import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'api_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String message;
  final User user;

  LoginResponse({
    required this.message,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  final User user;

  RegisterResponse({
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => 
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class TokenResponse {
  final String token;
  final StreamUser user;

  TokenResponse({
    required this.token,
    required this.user,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => 
      _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

@JsonSerializable()
class StreamUser {
  final String id;
  final String name;
  final String? image;

  StreamUser({
    required this.id,
    required this.name,
    this.image,
  });

  factory StreamUser.fromJson(Map<String, dynamic> json) => 
      _$StreamUserFromJson(json);
  Map<String, dynamic> toJson() => _$StreamUserToJson(this);
}

@JsonSerializable()
class CreateChannelResponse {
  final bool success;
  final String? streamCid;
  final int? dbId;
  final String? channelId;
  final String message;
  final String? action;

  CreateChannelResponse({
    required this.success,
    this.streamCid,
    this.dbId,
    this.channelId,
    required this.message,
    this.action,
  });

  factory CreateChannelResponse.fromJson(Map<String, dynamic> json) => 
      _$CreateChannelResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChannelResponseToJson(this);
}

@JsonSerializable()
class ErrorResponse {
  final String error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => 
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}