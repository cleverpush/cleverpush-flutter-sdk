import 'dart:async';
import 'package:cleverpush_flutter/src/notification.dart';
import 'package:flutter/services.dart';

export 'src/notification.dart';

typedef void NotificationReceivedHandler(CPNotificationReceivedResult receivedResult);
typedef void NotificationOpenedHandler(CPNotificationOpenedResult openedResult);
typedef void SubscribedHandler(String? subscriptionId);

class CleverPush {
  static CleverPush shared = new CleverPush();

  MethodChannel _channel = const MethodChannel('CleverPush');
  NotificationReceivedHandler? _notificationReceivedHandler;
  NotificationOpenedHandler? _notificationOpenedHandler;
  SubscribedHandler? _subscribedHandler;
  List<dynamic> subScriptionTopicsList = <dynamic>[];
  List<dynamic> availableTopicList = <dynamic>[];
  List<dynamic> notificationList = <dynamic>[];

  CleverPush() {
    this._channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> init(String channelId, [bool? autoRegister]) async {
    print("CleverPush: Flutter initializing");
    await _channel.invokeMethod('CleverPush#init',
        {'channelId': channelId, 'autoRegister': autoRegister});
  }

  void setNotificationReceivedHandler(NotificationReceivedHandler handler) {
    _notificationReceivedHandler = handler;
  }

  void setNotificationOpenedHandler(NotificationOpenedHandler handler) {
    _notificationOpenedHandler = handler;
    _channel.invokeMethod("CleverPush#initNotificationOpenedHandlerParams");
  }

  void setSubscribedHandler(SubscribedHandler handler) {
    _subscribedHandler = handler;
  }

  Future<void> subscribe() async {
    return await _channel.invokeMethod("CleverPush#subscribe");
  }

  Future<void> unsubscribe() async {
    return await _channel.invokeMethod("CleverPush#unsubscribe");
  }

  Future<bool?> isSubscribed() async {
    return await _channel.invokeMethod("CleverPush#isSubscribed");
  }

  Future<void> showTopicsDialog() async {
    return await _channel.invokeMethod("CleverPush#showTopicsDialog");
  }

  Future<List<dynamic>> getNotifications() async {
    notificationList =
        await _channel.invokeMethod("CleverPush#getNotifications");
    print(notificationList.length.toString());
    return notificationList;
  }

  Future<void> setSubscriptionTopics(List<String> topics) async {
    await _channel
        .invokeMethod('CleverPush#setSubscriptionTopics', {'topics': topics});
  }

  Future<List<dynamic>> getAvailableTopics() async {
    availableTopicList =
        await _channel.invokeMethod("CleverPush#getAvailableTopics");
    return availableTopicList;
  }

  Future<List<dynamic>> getSubscriptionTopics() async {
    subScriptionTopicsList =
        await _channel.invokeMethod("CleverPush#getSubscriptionTopics");
    return subScriptionTopicsList;
  }

  Future<Null> _handleMethod(MethodCall call) async {
    try {
      if (call.method == 'CleverPush#handleNotificationReceived' &&
          this._notificationReceivedHandler != null) {
        this._notificationReceivedHandler!(CPNotificationReceivedResult(
            Map<String, dynamic>.from(call.arguments)));
      } else if (call.method == 'CleverPush#handleSubscribed' &&
          this._subscribedHandler != null) {
        this._subscribedHandler!(call.arguments['subscriptionId']);
      } else if (call.method == 'CleverPush#handleNotificationOpened' &&
          this._notificationOpenedHandler != null) {
        this._notificationOpenedHandler!(CPNotificationOpenedResult(
            Map<String, dynamic>.from(call.arguments)));
      } else {
        print("CleverPush: unknown method: " + call.method);
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}