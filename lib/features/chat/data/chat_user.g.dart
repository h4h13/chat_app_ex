// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => _ChatUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  pushToken: json['pushToken'] as String?,
);

Map<String, dynamic> _$ChatUserToJson(_ChatUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'pushToken': instance.pushToken,
};
