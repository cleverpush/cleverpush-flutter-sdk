import 'package:flutter/foundation.dart';
import 'dart:convert';

class CPNotification extends JSONStringRepresentable {
  CPNotificationPayload payload;

  CPNotification(Map<String, dynamic> json) {
    this.payload =
        CPNotificationPayload(json['payload'].cast<String, dynamic>());
  }

  String jsonRepresentation() {
    return this.payload.jsonRepresentation();
  }
}

class CPNotificationPayload extends JSONStringRepresentable {
  String id;
  String title;
  String text;
  String url;
  String iconUrl;
  String mediaUrl;
  Map<String, dynamic> customData;
  Map<String, dynamic> rawPayload;

  CPNotificationPayload(Map<String, dynamic> json) {
    this.id = json['_id'] as String;
    if (json.containsKey('title'))
      this.title = json['title'] as String;
    if (json.containsKey('text'))
      this.text = json['text'] as String;
    if (json.containsKey('url'))
      this.url = json['url'] as String;
    if (json.containsKey('iconUrl'))
      this.url = json['iconUrl'] as String;
    if (json.containsKey('mediaUrl'))
      this.url = json['mediaUrl'] as String;
    if (json.containsKey('customData'))
      this.customData = json['customData'].cast<String, dynamic>();

    if (json.containsKey('rawPayload')) {
      var raw = json['rawPayload'] as String;
      JsonDecoder decoder = JsonDecoder();
      this.rawPayload = decoder.convert(raw);
    }
  }

  String jsonRepresentation() => convertToJsonString(this.rawPayload);
}

class CPNotificationOpenedResult {
  CPNotification notification;

  CPNotificationOpenedResult(Map<String, dynamic> json) {
    this.notification =
        CPNotification(json['notification'].cast<String, dynamic>());
  }
}

abstract class JSONStringRepresentable {
  String jsonRepresentation();

  String convertToJsonString(Map<String, dynamic> object) => JsonEncoder
      .withIndent('  ')
      .convert(object)
      .replaceAll("\\n", "\n")
      .replaceAll("\\", "");
}
