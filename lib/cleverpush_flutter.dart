import 'dart:async';
import 'package:cleverpush_flutter/src/notification.dart';
import 'package:flutter/services.dart';

export 'src/notification.dart';

typedef void NotificationReceivedHandler(CPNotificationReceivedResult receivedResult);
typedef void NotificationOpenedHandler(CPNotificationOpenedResult openedResult);
typedef void SubscribedHandler(String subscriptionId);

class CleverPush {
  static CleverPush shared = new CleverPush();

  MethodChannel _channel = const MethodChannel('CleverPush');

  NotificationReceivedHandler _notificationReceivedHandler;
  NotificationOpenedHandler _notificationOpenedHandler;
  SubscribedHandler _subscribedHandler;

  CleverPush() {
    this._channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> init(String channelId) async {
    await _channel.invokeMethod(
        'CleverPush#init', {'channelId': channelId});
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

  Future<bool> isSubscribed() async {
    return await _channel.invokeMethod("CleverPush#isSubscribed");
  }

  Future<void> showTopicsDialog() async {
    return await _channel.invokeMethod("CleverPush#showTopicsDialog");
  }

  Future<Null> _handleMethod(MethodCall call) async {
    if (call.method == 'CleverPush#handleNotificationReceived' &&
        this._notificationReceivedHandler != null) {
      this._notificationReceivedHandler(CPNotificationReceivedResult(call.arguments.cast<String, dynamic>()));
    } else if (call.method == 'CleverPush#handleSubscribed' &&
        this._subscribedHandler != null) {
      this._subscribedHandler(call.arguments.cast<String, dynamic>());
    } else if (call.method == 'CleverPush#handleNotificationOpened' &&
        this._notificationOpenedHandler != null) {
      this._notificationOpenedHandler(CPNotificationOpenedResult(call.arguments.cast<String, dynamic>()));
    }
    return null;
  }
}
