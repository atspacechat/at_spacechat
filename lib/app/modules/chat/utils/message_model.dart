import 'dart:convert';

import 'dart:typed_data';

enum MessageType { INCOMING, OUTGOING, INITIAL }
enum MessageContentType { TEXT, IMAGE }

extension MessageContentTypeExt on MessageContentType {
  static MessageContentType? fromIndex(int index) {
    if (index >= 0 && index < MessageContentType.values.length) {
      return MessageContentType.values[index];
    } else {
      return null;
    }
  }
}

/// data of each message
class Message {
  String? id;
  int? time;
  String? message;
  MessageType? type;
  MessageContentType? contentType;
  String? sender;
  Uint8List? imageData;

  Message(
      {this.id,
        this.time,
        this.message,
        this.type,
        this.contentType = MessageContentType.TEXT,
        this.sender,
        this.imageData});

  Message copyWith(
      {String? id,
        int? time,
        String? message,
        MessageType? type,
        MessageContentType? contentType,
        String? sender,
        Uint8List? imageData}) {
    return Message(
        id: id ?? this.id,
        time: time ?? this.time,
        message: message ?? this.message,
        type: type ?? this.type,
        contentType: contentType ?? this.contentType,
        sender: sender ?? this.sender,
        imageData: imageData ?? this.imageData);
  }

  Map<String, dynamic> toMap() {
    var t;
    if (type == MessageType.values[0]){
      t = 0;
    }else if(type == MessageType.values[1]){
      t = 1;
    }else{
      t = 2;
    }
    return {
      'id': id,
      'time': time,
      'message': message,
      'type': t,
      'content_type': contentType?.index,
      'sender': sender,
      'imageData': imageData
    };
  }

  factory Message.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Message();

    return Message(
        id: map['id'],
        time: map['time'],
        message: map['message'],
        type: MessageType.values[map['type']],
        contentType: MessageContentTypeExt.fromIndex(map['content_type'] ?? 0),
        sender: map['sender'],
        imageData: map['imageData'] ?? Uint8List(0));
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() =>
      'Message(id: $id, time: $time, message: $message, type: ${type.toString()}, '
          'contentType ${contentType.toString()}, sender: $sender, imageType: $imageData)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message &&
        o.id == id &&
        o.time == time &&
        o.message == message &&
        o.type == type &&
        o.contentType == contentType &&
        o.sender == sender &&
        o.imageData == imageData;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      time.hashCode ^
      message.hashCode ^
      type.hashCode ^
      sender.hashCode ^
      imageData.hashCode;
}