import 'package:flutter/foundation.dart';
import 'dart:convert';

class CPNotification extends JSONStringRepresentable {
  String id;
  String title;
  String text;
  String url;
  String iconUrl;
  String mediaUrl;
  Map<String, dynamic> customData;
  Map<String, dynamic> rawPayload;

  CPNotification(Map<String, dynamic> json) {
    this.rawPayload = json;
    this.id = json['_id'] as String;
    if (json.containsKey('title'))
      this.title = json['title'] as String;
    if (json.containsKey('text'))
      this.text = json['text'] as String;
    if (json.containsKey('url'))
      this.url = json['url'] as String;
    if (json.containsKey('iconUrl'))
      this.iconUrl = json['iconUrl'] as String;
    if (json.containsKey('mediaUrl'))
      this.mediaUrl = json['mediaUrl'] as String;
    if (json.containsKey('customData'))
      this.customData = json['customData'].cast<String, dynamic>();
  }

  String jsonRepresentation() => convertToJsonString(this.rawPayload);
}

class CPNotificationOpenedResult {
  CPNotification notification;

  CPNotificationOpenedResult(Map<String, dynamic> json) {
    this.notification = CPNotification(json['notification'].cast<String, dynamic>());
  }
}

class CPNotificationReceivedResult {
  CPNotification notification;

  CPNotificationReceivedResult(Map<String, dynamic> json) {
    this.notification = CPNotification(json['notification'].cast<String, dynamic>());
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
