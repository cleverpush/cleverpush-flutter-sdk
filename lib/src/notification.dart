import 'json.dart';

class CPNotification extends JSONStringRepresentable {
  String? id;
  String? title;
  String? text;
  String? url;
  String? iconUrl;
  String? mediaUrl;
  String? createdAt;
  Map<String, dynamic>? customData;
  Map<String, dynamic>? rawPayload;
  bool? chatNotification;
  bool? silent;
  String? appBanner;

  CPNotification(Map<String, dynamic> json) {
    this.rawPayload = json;
    
    // Handle ID field variations between iOS (_id) and Android (id)
    if (json.containsKey('_id')) {
      this.id = json['_id'] as String?;
    } else if (json.containsKey('id')) {
      this.id = json['id'] as String?;
    }
    this.rawPayload?['id'] = this.id;
    
    if (json.containsKey('title')) {
      this.title = json['title'] as String?;
    }
    if (json.containsKey('text')) {
      this.text = json['text'] as String?;
    }
    if (json.containsKey('url')) {
      this.url = json['url'] as String?;
    }
    if (json.containsKey('iconUrl')) {
      this.iconUrl = json['iconUrl'] as String?;
    }
    if (json.containsKey('mediaUrl')) {
      this.mediaUrl = json['mediaUrl'] as String?;
    }
    if (json.containsKey('createdAt')) {
      this.createdAt = json['createdAt'] as String?;
    }
    if (json.containsKey('customData')) {
      this.customData = json['customData'].cast<String, dynamic>();
    }
    if (json.containsKey('chatNotification')) {
      this.chatNotification = json['chatNotification'] as bool?;
    }
    if (json.containsKey('silent')) {
      this.silent = json['silent'] as bool?;
    }
    if (json.containsKey('appBanner')) {
      this.appBanner = json['appBanner'] as String?;
    }
  }

  String jsonRepresentation() => convertToJsonString(this.rawPayload);
}

class CPNotificationOpenedResult {
  CPNotification? notification;

  CPNotificationOpenedResult(Map<String, dynamic> json) {
    this.notification = CPNotification(json['notification'].cast<String, dynamic>());
  }
}

class CPNotificationReceivedResult {
  CPNotification? notification;

  CPNotificationReceivedResult(Map<String, dynamic> json) {
    this.notification = CPNotification(json['notification'].cast<String, dynamic>());
  }
}
