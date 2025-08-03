// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  userId: json['userId'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  lastSeenAt: json['lastSeenAt'] == null
      ? null
      : DateTime.parse(json['lastSeenAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'email': instance.email,
  'name': instance.name,
  'image': instance.image,
  'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};
