import 'dart:async';
import 'package:cleverpush_flutter/src/notification.dart';
import 'package:cleverpush_flutter/src/app_banner.dart';
import 'package:flutter/services.dart';

export 'src/notification.dart';
export 'src/app_banner.dart';

typedef void NotificationReceivedHandler(CPNotificationReceivedResult receivedResult);
typedef void NotificationOpenedHandler(CPNotificationOpenedResult openedResult);
typedef void InitializationHandler(bool success, String? failureMessage);
typedef void SubscriptionTopicsHandler(bool success, String? failureMessage);
typedef void SubscribedHandler(String? subscriptionId);
typedef void ChatUrlOpenedHandler(String url);
typedef void AppBannerShownHandler(CPAppBanner appBanner);
typedef void AppBannerOpenedHandler(CPAppBannerAction action);
typedef void LogHandler(String message);

class CleverPush {
  static CleverPush shared = new CleverPush();

  MethodChannel _channel = const MethodChannel('CleverPush');
  NotificationReceivedHandler? _notificationReceivedHandler;
  NotificationOpenedHandler? _notificationOpenedHandler;
  InitializationHandler? _initializedHandler;
  SubscriptionTopicsHandler ? _subscriptionTopicsHandler;
  SubscribedHandler? _subscribedHandler;
  ChatUrlOpenedHandler? _chatUrlOpenedHandler;
  AppBannerShownHandler? _appBannerShownHandler;
  AppBannerOpenedHandler? _appBannerOpenedHandler;
  LogHandler? _logHandler;

  CleverPush() {
    this._channel.setMethodCallHandler(_handleMethod);
  }

  Future<void> init(String channelId, [bool autoRegister = true]) async {
    print("CleverPush: Flutter initializing with channelId: " + channelId + " and autoRegister: " + (autoRegister ? 'true' : 'false'));
    await _channel.invokeMethod('CleverPush#init', {'channelId': channelId, 'autoRegister': autoRegister});
  }

  Future<void> setShowNotificationsInForeground(bool show) async {
    await _channel.invokeMethod('CleverPush#setShowNotificationsInForeground', {'show': show});
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

  void setChatUrlOpenedHandler(ChatUrlOpenedHandler handler) {
    _chatUrlOpenedHandler = handler;
  }

  void setAppBannerShownHandler(AppBannerShownHandler handler) {
    _appBannerShownHandler = handler;
  }

  void setAppBannerOpenedHandler(AppBannerOpenedHandler handler) {
    _appBannerOpenedHandler = handler;
  }

  void setLogHandler(LogHandler handler) {
    _logHandler = handler;
    _channel.invokeMethod("CleverPush#setLogListener");
  }

  void setInitializedHandler(InitializationHandler handler) {
    _initializedHandler = handler;
  }
  
  void setBrandingColor(String color) {
    _channel.invokeMethod("CleverPush#setBrandingColor", {'color': color});
  }

  Future<String> subscribe() async {
    final String result = await _channel.invokeMethod("CleverPush#subscribe");
    return result;
  }

  Future<void> unsubscribe() async {
    return await _channel.invokeMethod("CleverPush#unsubscribe");
  }

  Future<String> getSubscriptionId() async {
    return await _channel.invokeMethod("CleverPush#getSubscriptionId");
  }

  Future<String> getDeviceToken() async {
    return await _channel.invokeMethod("CleverPush#getDeviceToken");
  }

  Future<void> enableAppBanners() async {
    return await _channel.invokeMethod("CleverPush#enableAppBanners");
  }

  Future<void> disableAppBanners() async {
    return await _channel.invokeMethod("CleverPush#disableAppBanners");
  }

  Future<void> enableDevelopmentMode() async {
    return await _channel.invokeMethod("CleverPush#enableDevelopmentMode");
  }

  Future<bool?> isSubscribed() async {
    return await _channel.invokeMethod("CleverPush#isSubscribed");
  }

  Future<bool?> areNotificationsEnabled() async {
    return await _channel.invokeMethod("CleverPush#areNotificationsEnabled");
  }

  Future<void> showTopicsDialog() async {
    return await _channel.invokeMethod("CleverPush#showTopicsDialog");
  }

  Future<List<CPNotification>> getNotifications() async {
    List<dynamic>? notifications = await _channel.invokeMethod("CleverPush#getNotifications");
    if (notifications != null) {
      List<CPNotification> cpNotifications = notifications.map((notification) {
        return CPNotification(notification.cast<String, dynamic>());
      }).toList();
      return cpNotifications;
    } else {
      return [];
    }
  }

  Future<List<CPNotification>> getNotificationsWithApi(bool combineWithApi) async {
    List<dynamic>? remoteNotificationList = await _channel.invokeMethod(
      "CleverPush#getNotificationsWithApi",
      {'combineWithApi': combineWithApi}
    );
    if (remoteNotificationList != null) {
      List<CPNotification> cpNotifications = remoteNotificationList.map((notification) {
        return CPNotification(notification.cast<String, dynamic>());
      }).toList();
      return cpNotifications;
    } else {
      return [];
    }
  }

  void setSubscriptionTopicsHandler(SubscriptionTopicsHandler handler) {
    _subscriptionTopicsHandler = handler;
  }

  Future<dynamic> setSubscriptionTopics(List<String> topics) async {
    return await _channel.invokeMethod('CleverPush#setSubscriptionTopics', {'topics': topics});
  }

  Future<List<dynamic>> getAvailableTopics() async {
    return await _channel.invokeMethod("CleverPush#getAvailableTopics");
  }

  Future<List<dynamic>> getSubscriptionTopics() async {
    return await _channel.invokeMethod("CleverPush#getSubscriptionTopics");
  }

  Future<List<dynamic>> getAvailableTags() async {
    return await _channel.invokeMethod("CleverPush#getAvailableTags");
  }

  Future<List<dynamic>> getSubscriptionTags() async {
    return await _channel.invokeMethod("CleverPush#getSubscriptionTags");
  }

  Future<dynamic> addSubscriptionTag(String id) async {
    return await _channel.invokeMethod("CleverPush#addSubscriptionTag", {'id': id});
  }

  Future<dynamic> addSubscriptionTags(List<String> tagIds) async {
    return await _channel.invokeMethod("CleverPush#addSubscriptionTags", {'ids': tagIds});
  }

  Future<dynamic> removeSubscriptionTag(String id) async {
    return await _channel.invokeMethod("CleverPush#removeSubscriptionTag", {'id': id});
  }

  Future<dynamic> removeSubscriptionTags(List<String> tagIds) async {
    return await _channel.invokeMethod("CleverPush#removeSubscriptionTags", {'ids': tagIds});
  }

  Future<List<dynamic>> getAvailableAttributes() async {
    return await _channel.invokeMethod("CleverPush#getAvailableAttributes");
  }

  Future<Map<dynamic, dynamic>> getSubscriptionAttributes() async {
    return await _channel.invokeMethod("CleverPush#getSubscriptionAttributes");
  }

  Future<dynamic> getSubscriptionAttribute(String id) async {
    return await _channel.invokeMethod("CleverPush#getSubscriptionAttribute", {'id': id});
  }

  Future<dynamic> setSubscriptionAttribute(String id, String value) async {
    return await _channel.invokeMethod("CleverPush#setSubscriptionAttribute", {'id': id, 'value': value});
  }

  Future<dynamic> setTrackingConsentRequired(bool consentRequired) async {
    return await _channel.invokeMethod("CleverPush#setTrackingConsentRequired", {'consentRequired': consentRequired});
  }

  Future<dynamic> setTrackingConsent(bool hasConsent) async {
    return await _channel.invokeMethod("CleverPush#setTrackingConsent", {'hasConsent': hasConsent});
  }

  Future<dynamic> setIgnoreDisabledNotificationPermission(bool ignore) async {
    return await _channel.invokeMethod("CleverPush#setIgnoreDisabledNotificationPermission", {'ignore': ignore});
  }

  Future<dynamic> setAutoRequestNotificationPermission(bool autoRequest) async {
    return await _channel.invokeMethod("CleverPush#setAutoRequestNotificationPermission", {'autoRequest': autoRequest});
  }

  Future<dynamic> trackPageView(String url) async {
    return await _channel.invokeMethod("CleverPush#trackPageView", {'url': url});
  }

  Future<dynamic> setAuthorizerToken(String token) async {
    return await _channel.invokeMethod("CleverPush#setAuthorizerToken", {'token': token});
  }

  Future<dynamic> setSubscriptionLanguage(String language) async {
    return await _channel.invokeMethod("CleverPush#setSubscriptionLanguage", {'language': language});
  }

  Future<dynamic> setSubscriptionCountry(String country) async {
    return await _channel.invokeMethod("CleverPush#setSubscriptionCountry", {'country': country});
  }

  Future<dynamic> setMaximumNotificationCount(int count) async {
    return await _channel.invokeMethod("CleverPush#setMaximumNotificationCount", {'count': count});
  }

  Future<dynamic> pushSubscriptionAttributeValue(String id, String value) async {
    return await _channel.invokeMethod("CleverPush#pushSubscriptionAttributeValue", {'id': id, 'value': value});
  }

  Future<dynamic> pullSubscriptionAttributeValue(String id, String value) async {
    return await _channel.invokeMethod("CleverPush#pullSubscriptionAttributeValue", {'id': id, 'value': value});
  }

  Future<dynamic> trackEvent(String eventName, [dynamic argument]) async {
    Map<String, dynamic> arguments = {'eventName': eventName};
    if (argument is Map) {
      arguments['properties'] = argument;
    } else if (argument is double) {
      arguments['amount'] = argument;
    }
    return await _channel.invokeMethod("CleverPush#trackEvent", arguments);
  }

  Future<dynamic> triggerFollowUpEvent(String eventName, [Map<String, String> parameters = const {}]) async {
    return await _channel.invokeMethod("CleverPush#triggerFollowUpEvent", {'eventName': eventName, 'parameters': parameters});
  }

  Future<dynamic> showAppBanner(String id, [void Function()? closedHandler]) async {
    if (closedHandler == null) {
      return await _channel.invokeMethod("CleverPush#showAppBanner", {'id': id});
    }
    
    return await _channel.invokeMethod("CleverPush#showAppBannerWithClosedHandler", {
      'id': id
    }).then((_) {
      closedHandler();
    });
  }

  Future<Null> _handleMethod(MethodCall call) async {
    try {
      if (
        call.method == 'CleverPush#handleNotificationReceived'
        && this._notificationReceivedHandler != null
      ) {
        this._notificationReceivedHandler!(CPNotificationReceivedResult(
          Map<String, dynamic>.from(call.arguments))
        );
      } else if (
        call.method == 'CleverPush#handleSubscribed'
        && this._subscribedHandler != null
      ) {
        this._subscribedHandler!(call.arguments['subscriptionId']);
      } else if (
        call.method == 'CleverPush#handleNotificationOpened'
        && this._notificationOpenedHandler != null
      ) {
        this._notificationOpenedHandler!(CPNotificationOpenedResult(
          Map<String, dynamic>.from(call.arguments))
        );
      } else if (
        call.method == 'CleverPush#handleChatUrlOpened'
        && this._chatUrlOpenedHandler != null
      ) {
        String url = call.arguments['url'];
        this._chatUrlOpenedHandler!(url);
      } else if (
        call.method == 'CleverPush#handleAppBannerShown'
        && this._appBannerShownHandler != null
      ) {
        this._appBannerShownHandler!(CPAppBanner(
          Map<String, dynamic>.from(call.arguments['appBanner']))
        );
      } else if (
        call.method == 'CleverPush#handleInitialized'
        && this._initializedHandler != null
      ) {
        this._initializedHandler!(call.arguments['success'] ?? false, call.arguments['failureMessage']);
      } else if (
        call.method == 'CleverPush#handleSubscriptionTopics'
        && this._subscriptionTopicsHandler != null
      ) {
        this._subscriptionTopicsHandler!(call.arguments['success'] ?? false, call.arguments['failureMessage']);
      } else if (
        call.method == 'CleverPush#handleAppBannerOpened'
        && this._appBannerOpenedHandler != null
      ) {
        this._appBannerOpenedHandler!(CPAppBannerAction(
          Map<String, dynamic>.from(call.arguments['action']))
        );
      } else if (
        call.method == 'CleverPush#handleLog'
        && this._logHandler != null
      ) {
        String message = call.arguments['message'];
        this._logHandler!(message);
      } else {
        print("CleverPush: unknown method: " + call.method);
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}
