// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  senderId: json['senderId'] as String,
  receiverId: json['receiverId'] as String,
  content: json['content'] as String,
  timestamp: Message.timestampFromJson(json['timestamp']),
  senderEmail: json['senderEmail'] as String?,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'senderId': instance.senderId,
  'receiverId': instance.receiverId,
  'content': instance.content,
  'timestamp': Message.timestampToJson(instance.timestamp),
  'senderEmail': instance.senderEmail,
};
