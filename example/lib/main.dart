import 'dart:async';
import 'package:cleverpush_flutter/cleverpush_flutter.dart';
import 'package:cleverpush_flutter/cleverpush_chat_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";

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
      this.setState(() {
        _debugLabelString =
            "Notification received: \n${result.notification!.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    CleverPush.shared
        .setNotificationOpenedHandler((CPNotificationOpenedResult result) {
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

    CleverPush.shared.setBrandingColor("#ff0000");

    // CleverPush Channel ID
    await CleverPush.shared.init("7R8nkAxtrY5wy5TsS", true);

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
    var notifications = await CleverPush.shared.getNotifications();
    if (notifications.isNotEmpty) {
      print(notifications[0]);
    }
    this.setState(() {
      _debugLabelString = notifications.length.toString();
    });
  }

  void _getNotificationsWithApi() async {
    bool combineWithApi = true;
    var remoteNotifications =
        await CleverPush.shared.getNotificationsWithApi(combineWithApi);
    if (remoteNotifications.isNotEmpty) {
      print(remoteNotifications[0]);
    }
    this.setState(() {
      _debugLabelString = remoteNotifications.length.toString();
    });
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
    List<String> topics = ['hello', 'world'];
    CleverPush.shared.setSubscriptionTopics(topics);
  }

  void _getAvailableTopics() async {
    var topicIds = await CleverPush.shared.getAvailableTopics();
    if (topicIds.isNotEmpty) {
      print(topicIds[0]);
    }
    this.setState(() {
      _debugLabelString = topicIds.length.toString();
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
    CleverPush.shared.addSubscriptionTag('test');
  }

  void _removeSubscriptionTag() {
    CleverPush.shared.removeSubscriptionTag('test');
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
    CleverPush.shared.trackEvent("test");
  }

  void _triggerFollowUpEvent() async {
    CleverPush.shared.triggerFollowUpEvent("test", {
      "test": "test",
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
                      new CleverPushButton( "Show Chat View", () {
                        Navigator.pushNamed(context, '/chat');
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
                          "Get Available Tags", _getAvailableTags, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Track Event", _trackEvent, true)
                    ]),
                    new TableRow(children: [
                      new CleverPushButton(
                          "Track Follow-Up Event", _triggerFollowUpEvent, true)
                    ]),
                    new TableRow(children: [
                      Container(
                        height: 8.0,
                      )
                    ]),
                    new TableRow(children: [
                      new Container(
                        child: new Text(_debugLabelString),
                        alignment: Alignment.center,
                      )
                    ]),
                  ],
                ),
              ),
            ),
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
