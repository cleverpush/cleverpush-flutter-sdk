import 'dart:async';

import 'package:cleverpush_flutter/cleverpush_chat_view.dart';
import 'package:cleverpush_flutter/cleverpush_flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";
  bool _isInitialized = false;
  String? _lastOpenedNotificationId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    CleverPush.shared.setShowNotificationsInForeground(false);
    CleverPush.shared.enableDevelopmentMode();

    CleverPush.shared
        .setNotificationReceivedHandler((CPNotificationReceivedResult result) {
      _lastOpenedNotificationId = result.notification?.id;
      print("_lastOpenedNotificationId: $_lastOpenedNotificationId");
      this.setState(() {
        _debugLabelString =
            "Notification received: \n${result.notification!.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    CleverPush.shared
        .setNotificationOpenedHandler((CPNotificationOpenedResult result) {
      //Mark Notification as Read
      /*if (result.notification != null) {
        result.notification!.setRead(true);
      }*/
      this.setState(() {
        _debugLabelString =
            "Notification opened: \n${result.notification!.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    CleverPush.shared.setSubscribedHandler((subscriptionId) {
      this.setState(() {
        _debugLabelString = "Subscribed: " + subscriptionId!;
      });

      print("Subscribed: $subscriptionId");
    });

    CleverPush.shared.setInitializedHandler((bool success, String? failureMessage) {
      this.setState(() {
        _isInitialized = success;
        if (success) {
          _debugLabelString = "Initialized successfully";
        } else {
          _debugLabelString = "Initialization failed: " + (failureMessage ?? "Unknown error");
        }
      });
    });

    CleverPush.shared.setSubscriptionTopicsHandler((bool success, String? failureMessage) {
      this.setState(() {
        if (success) {
          _debugLabelString = "Topic subscribed successfully";
        } else {
          _debugLabelString = "Topic subscription failed: " + (failureMessage ?? "Unknown error");
        }
      });
    });

    CleverPush.shared.setAppBannerOpenedHandler((CPAppBannerAction action) {
      print("Banner action URL: \n${action.url}");
    });

    CleverPush.shared.setAppBannerShownHandler((CPAppBanner appBanner) {
      this.setState(() {
        _debugLabelString = "APP BANNER SHOWN: " + appBanner.name!;
      });
    });

    // CleverPush Channel ID
    await CleverPush.shared.init("CHANNEL_ID", true);

    CleverPush.shared.enableAppBanners();

    CleverPush.shared.setBrandingColor("#ff0000");

    CleverPush.shared.setChatUrlOpenedHandler((url) {
      Widget continueButton = TextButton(
        child: Text("Ok"),
        onPressed: () => Navigator.pop(context, 'Ok'),
      );
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Chat URL opened'),
          content: Text(url),
          actions: <Widget>[
            continueButton,
          ],
        ),
      );
    });
  }

  void _handleSubscribe() async {
    print("Prompting for Permission");
    var id = await CleverPush.shared.subscribe();
    print("Subscribed: $id");
  }

  void _handleUnsubscribe() {
    CleverPush.shared.unsubscribe();
  }

  void _handleIsSubscribed() {
    CleverPush.shared.isSubscribed().then((status) {
      this.setState(() {
        _debugLabelString = status.toString();
      });
    });
  }

  void _handleAreNotificationsEnabled() {
    CleverPush.shared.areNotificationsEnabled().then((status) {
      this.setState(() {
        _debugLabelString = status.toString();
      });
    });
  }

  void _handleTopicsDialog() {
    CleverPush.shared.showTopicsDialog();
  }

  void _getNotifications() async {
    List<CPNotification> notifications = await CleverPush.shared.getNotifications();
    if (notifications.isNotEmpty) {
      print("Get Notifications: " + notifications[0].jsonRepresentation());
    }
    this.setState(() {
      _debugLabelString = notifications.length.toString();
    });
  }

  void _getNotificationsWithApi() async {
    bool combineWithApi = true;
    List<CPNotification> remoteNotifications =
        await CleverPush.shared.getNotificationsWithApi(combineWithApi);
    if (remoteNotifications.isNotEmpty) {
      print("Get Notifications With API: " + remoteNotifications[0].jsonRepresentation());
    }
    this.setState(() {
      _debugLabelString = remoteNotifications.length.toString();
    });
  }

  void _removeNotification() async {
    final notificationId = _lastOpenedNotificationId;
    if (notificationId == null || notificationId.isEmpty) {
      print('No last opened notification ID available');
      return;
    }

    try {
      await CleverPush.shared.removeNotification(notificationId);
      print('Notification removed: $notificationId');
    } catch (e) {
      print('Failed to remove notification: $e');
    }
  }

  void _removeFromNotificationCenter() async {
    final notificationId = _lastOpenedNotificationId;
    if (notificationId == null || notificationId.isEmpty) {
      print('No last opened notification ID available');
      return;
    }

    try {
      await CleverPush.shared.removeNotification(
        notificationId, removeFromNotificationCenter: true,
      );
      print('Notification removed: $notificationId');
    } catch (e) {
      print('Failed to remove notification: $e');
    }
  }

  void _clearNotificationsFromNotificationCenter() {
    CleverPush.shared.clearNotificationsFromNotificationCenter();
  }

  void _getSubscriptionTopics() async {
    var topicIds = await CleverPush.shared.getSubscriptionTopics();
    String topicIdsString = "";
    for (var i = 0; i < topicIds.length; i++) {
      if (topicIdsString.isEmpty) {
        topicIdsString = topicIds[i];
      } else {
        topicIdsString = topicIdsString + "," + topicIds[i];
      }
    }
    this.setState(() {
      _debugLabelString = topicIdsString;
    });
  }

  void _setSubscriptionTopics() {
    List<String> topics = ['TOPIC_ID1', 'TOPIC_ID2'];
    CleverPush.shared.setSubscriptionTopics(topics);
  }

  void _getAvailableTopics() async {
    var topics = await CleverPush.shared.getAvailableTopics();
    if (topics.isNotEmpty) {
      print(topics[0]);
    }
    this.setState(() {
      _debugLabelString = topics.length.toString();
    });
  }

  void _getSubscriptionTags() async {
    var tagIds = await CleverPush.shared.getSubscriptionTags();
    String tagIdsString = "";
    for (var i = 0; i < tagIds.length; i++) {
      if (tagIdsString.isEmpty) {
        tagIdsString = tagIds[i];
      } else {
        tagIdsString = tagIdsString + "," + tagIds[i];
      }
    }
    this.setState(() {
      _debugLabelString = tagIdsString;
    });
  }

  void _addSubscriptionTag() {
    CleverPush.shared.addSubscriptionTag('TAG_ID');
  }

  void _addSubscriptionTags() {
    List<String> tagIds = ['TAG_ID1', 'TAG_ID2'];
    CleverPush.shared.addSubscriptionTags(tagIds);
  }

  void _removeSubscriptionTag() {
    CleverPush.shared.removeSubscriptionTag('TAG_ID');
  }

  void _removeSubscriptionTags() {
    List<String> tagIds = ['TAG_ID1', 'TAG_ID2'];
    CleverPush.shared.removeSubscriptionTags(tagIds);
  }

  void _getAvailableTags() async {
    var tagIds = await CleverPush.shared.getAvailableTags();
    if (tagIds.isNotEmpty) {
      print(tagIds[0]);
    }
    this.setState(() {
      _debugLabelString = tagIds.length.toString();
    });
  }

  void _trackEvent() async {
    CleverPush.shared.trackEvent("EVENT_NAME");
  }

  void _triggerFollowUpEvent() async {
    CleverPush.shared.triggerFollowUpEvent("EVENT_NAME", {
      "property_1": "value",
    });
  }

  void _pushSubscriptionAttributeValue() async {
    CleverPush.shared.pushSubscriptionAttributeValue("ATTRIBUTE_KEY","ATTRIBUTE_VALUE");
  }

  void _pullSubscriptionAttributeValue() async {
    CleverPush.shared.pullSubscriptionAttributeValue("ATTRIBUTE_KEY","ATTRIBUTE_VALUE");
  }

  void _showAppBanner() async {
    CleverPush.shared.showAppBanner("APP_BANNER_ID");
  }

  void _showAppBannerWithCallback() async {
    CleverPush.shared.showAppBanner("APP_BANNER_ID", () {
      this.setState(() {
        _debugLabelString = "APP BANNER CLOSED";
      });
      print("APP BANNER CLOSED");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('CleverPush Flutter'),
              backgroundColor: Color.fromARGB(255, 33, 33, 33),
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: new Table(
                  children: [
                    new TableRow(children: [
                      new Container(
                        child: new Text(_debugLabelString),
                        alignment: Alignment.center,
                      )
                    ]),
                    new TableRow(children: [
                      Container(
                        height: 8.0,
                      )
                    ]),
                    new TableRow(children: [
                      new CleverPushButton( "Show Chat View", () {
                        Navigator.pushNamed(context, '/chat');
                      }, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton("Show Story View", () {
                        Navigator.pushNamed(context, '/story');
                      }, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton("Subscribe", _handleSubscribe, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Unsubscribe", _handleUnsubscribe, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Is Subscribed?", _handleIsSubscribed, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Are Notifications Enabled?", _handleAreNotificationsEnabled, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Show topics dialog", _handleTopicsDialog, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Get Notifications", _getNotifications, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton("Get Remote Notifications",
                          _getNotificationsWithApi, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Remove Notification", _removeNotification, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Remove Notification from Local and Center", _removeFromNotificationCenter, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Clear All Notifications From Notification Center", _clearNotificationsFromNotificationCenter, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Get Subscription Topics", _getSubscriptionTopics, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Set Subscription Topics", _setSubscriptionTopics, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Get Available Topics", _getAvailableTopics, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Get Subscription Tags", _getSubscriptionTags, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Add Subscription Tag", _addSubscriptionTag, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Remove Subscription Tag", _removeSubscriptionTag, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Add Subscription Tags", _addSubscriptionTags, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Remove Subscription Tags", _removeSubscriptionTags, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Get Available Tags", _getAvailableTags, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Track Event", _trackEvent, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Show App Banner", _showAppBanner, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Show App Banner With Callback", _showAppBannerWithCallback, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Track Follow-Up Event", _triggerFollowUpEvent, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Push Subscription Attribute Value", _pushSubscriptionAttributeValue, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Pull Subscription Attribute Value", _pullSubscriptionAttributeValue, true)
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
        '/story': (BuildContext context) {
          final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
          return new Scaffold(
            appBar: AppBar(
              title: const Text('Story View'),
            ),
            body: _isInitialized
                ? CleverPushStoryView(
                    widgetId: 'WIDGET_ID',
                    storyViewHeightAndroid: CleverPushStoryViewSize.wrapContent,
                    storyViewWidthAndroid: CleverPushStoryViewSize.matchParent,
                    storyViewHeightiOS: 130,
                    storyViewWidthiOS: MediaQuery.of(context).size.width.toInt(),
                    onOpened: (url) {
                      print('CleverPush storyView opened: ${url.toString()}');
                    },
                    darkModeEnabled: isDarkMode,

                    // BACKGROUND & TEXT COLORS
                    backgroundColor: "#A4BD87",
                    backgroundColorDarkMode: "#A4BD87",
                    textColor: "#000000",
                    textColorDarkMode: "#2196F3",

                    // TITLE ATTRIBUTES
                    titleVisibility: CleverPushVisibility.visible,
                    titlePosition: CleverPushStoryTitlePosition.positionInsideBottom,
                    titleTextSize: 38,
                    titleMinTextSize: 35,
                    titleMaxTextSize: 40,

                    // STORY ICON ATTRIBUTES
                    storyIconHeight: 90,
                    storyIconHeightPercentage: 75,
                    storyIconWidth: 85,
                    storyIconCornerRadius: 30.0,
                    storyIconSpace: 0.0,
                    storyIconShadow: false,

                    // BORDER ATTRIBUTES
                    borderVisibility: CleverPushVisibility.visible,
                    borderMargin: 4,
                    borderWidth: 5,
                    borderColor: "#2196F3",
                    borderColorDarkMode: "#FFC107",
                    borderColorLoading: "#B66C54",
                    borderColorLoadingDarkMode: "#4CAF50",

                    // SUB STORY UNREAD COUNT ATTRIBUTES
                    subStoryUnreadCountVisibility: CleverPushVisibility.visible,
                    subStoryUnreadCountBackgroundColor: "#C62828",
                    subStoryUnreadCountBackgroundColorDarkMode: "#000000",
                    subStoryUnreadCountTextColor: "#FFFFFF",
                    subStoryUnreadCountTextColorDarkMode: "#FFFFFF",
                    subStoryUnreadCountBadgeHeight: 65,
                    subStoryUnreadCountBadgeWidth: 65,

                    // BEHAVIOR ATTRIBUTES
                    restrictToItems: 3,
                    closeButtonPosition: CleverPushStoryCloseButtonPosition.right,
                    sortToLastIndex: CleverPushStorySortToLastIndex.positionDefault,
                  )
                : Center(child: Text('Initializing...')),
          );
        },
        '/chat': (BuildContext context) {
          return new Scaffold(
            appBar: AppBar(
              title: const Text('Chat View'),
            ),
            body: new Container(
              child: CleverPushChatView(
                
              ),
            ),
          );
        },
      },
    );
  }
}

typedef void OnButtonPressed();

class CleverPushButton extends StatefulWidget {
  final String title;
  final OnButtonPressed onPressed;
  final bool enabled;

  CleverPushButton(this.title, this.onPressed, this.enabled);

  State<StatefulWidget> createState() => new CleverPushButtonState();
}

class CleverPushButtonState extends State<CleverPushButton> {
  @override
  Widget build(BuildContext context) {
    return new Table(
      children: [
        new TableRow(children: [
          new TextButton(
            child: new Text(widget.title),
            onPressed: widget.enabled ? widget.onPressed : null,
          )
        ]),
        new TableRow(children: [
          Container(
            height: 8.0,
          )
        ]),
      ],
    );
  }
}
