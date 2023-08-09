import 'json.dart';

class CPAppBanner extends JSONStringRepresentable {
  String? id;
  String? name;
  String? title;
  String? description;
  String? mediaUrl;
  Map<String, dynamic>? rawPayload;

  CPAppBanner(Map<String, dynamic> json) {
    this.rawPayload = json;
    this.id = json['_id'] as String?;
    if (json.containsKey('name')) {
      this.name = json['name'] as String?;
    }
    if (json.containsKey('title')) {
      this.title = json['title'] as String?;
    }
    if (json.containsKey('description')) {
      this.description = json['description'] as String?;
    }
    if (json.containsKey('mediaUrl')) {
      this.mediaUrl = json['mediaUrl'] as String?;
    }
  }

  String jsonRepresentation() => convertToJsonString(this.rawPayload);
}

class CPAppBannerAction extends JSONStringRepresentable {
  String? url;
  String? urlType;
  String? name;
  String? type;
  Map<String, dynamic>? rawPayload;

  CPAppBannerAction(Map<String, dynamic> json) {
    this.rawPayload = json;
    if (json.containsKey('url')) {
      this.url = json['url'] as String?;
    }
    if (json.containsKey('urlType')) {
      this.urlType = json['urlType'] as String?;
    }
    if (json.containsKey('name')) {
      this.name = json['name'] as String?;
    }
    if (json.containsKey('type')) {
      this.type = json['type'] as String?;
    }
  }

  String jsonRepresentation() => convertToJsonString(this.rawPayload);
}
