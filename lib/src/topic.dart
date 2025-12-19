import 'package:flutter/foundation.dart';

import 'json.dart';

class CPTopic extends JSONStringRepresentable {
  String? id;
  String? name;
  String? parentTopicId;
  bool? defaultUnchecked;
  String? fcmBroadcastTopic;
  String? externalId;
  Map<String, dynamic>? customData;
  Map<String, dynamic>? rawPayload;

  CPTopic(Map<String, dynamic> json) {
    this.rawPayload = json;

    this.id = json['id'] as String?;
    if (json.containsKey('name')) {
      this.name = json['name'] as String?;
    }
    if (json.containsKey('parentTopicId')) {
      this.parentTopicId = json['parentTopicId'] as String?;
    } else if (json.containsKey('parentTopic')) {
      this.parentTopicId = json['parentTopic'] as String?;
    }
    if (json.containsKey('defaultUnchecked')) {
      this.defaultUnchecked = json['defaultUnchecked'] as bool?;
    }
    if (json.containsKey('fcmBroadcastTopic')) {
      this.fcmBroadcastTopic = json['fcmBroadcastTopic'] as String?;
    }
    if (json.containsKey('externalId')) {
      this.externalId = json['externalId'] as String?;
    }
    if (json.containsKey('customData')) {
      final value = json['customData'];
      if (value is Map) {
        this.customData = Map<String, dynamic>.from(value);
      }
    }
  }

  CPTopic._internal({
    this.id,
    this.name,
    this.parentTopicId,
    this.defaultUnchecked,
    this.fcmBroadcastTopic,
    this.externalId,
    this.customData,
  }) {
    this.rawPayload = toMap();
  }

  factory CPTopic.fromMap(Map<String, dynamic> json) => CPTopic(json);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (parentTopicId != null) map['parentTopicId'] = parentTopicId;
    if (defaultUnchecked != null) map['defaultUnchecked'] = defaultUnchecked;
    if (fcmBroadcastTopic != null) map['fcmBroadcastTopic'] = fcmBroadcastTopic;
    if (externalId != null) map['externalId'] = externalId;
    if (customData != null) map['customData'] = customData;
    return map;
  }

  CPTopic copyWith({
    String? id,
    String? name,
    String? parentTopicId,
    bool? defaultUnchecked,
    String? fcmBroadcastTopic,
    String? externalId,
    Map<String, dynamic>? customData,
  }) {
    return CPTopic._internal(
      id: id ?? this.id,
      name: name ?? this.name,
      parentTopicId: parentTopicId ?? this.parentTopicId,
      defaultUnchecked: defaultUnchecked ?? this.defaultUnchecked,
      fcmBroadcastTopic: fcmBroadcastTopic ?? this.fcmBroadcastTopic,
      externalId: externalId ?? this.externalId,
      customData: customData ??
          (this.customData != null
              ? Map<String, dynamic>.from(this.customData!)
              : null),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CPTopic &&
        other.id == id &&
        other.name == name &&
        other.parentTopicId == parentTopicId &&
        other.defaultUnchecked == defaultUnchecked &&
        other.fcmBroadcastTopic == fcmBroadcastTopic &&
        other.externalId == externalId &&
        mapEquals(other.customData, customData);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      parentTopicId,
      defaultUnchecked,
      fcmBroadcastTopic,
      externalId,
      customData == null
          ? null
          : Object.hashAllUnordered(
              customData!.entries.map((e) => Object.hash(e.key, e.value)),
            ),
    );
  }

  @override
  String toString() => 'CPTopic(${toMap()})';

  String jsonRepresentation() => convertToJsonString(this.toMap());
}
