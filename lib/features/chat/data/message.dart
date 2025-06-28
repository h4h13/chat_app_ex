import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String senderId,
    required String receiverId,
    required String content,
    @JsonKey(
      fromJson: Message.timestampFromJson,
      toJson: Message.timestampToJson,
    )
    required Timestamp timestamp,
    String? senderEmail,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  static Timestamp timestampFromJson(dynamic json) {
    if (json is Timestamp) return json;
    if (json is Map<String, dynamic> && json.containsKey('_seconds')) {
      // Firestore Timestamp serialized as map
      return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
    }
    throw ArgumentError('Cannot parse Timestamp from json: $json');
  }

  static dynamic timestampToJson(Timestamp timestamp) => timestamp;
}
