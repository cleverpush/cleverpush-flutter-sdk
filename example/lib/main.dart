import 'dart:async';
import 'package:cleverpush_flutter/cleverpush_flutter.dart';
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

    // CleverPush Channel ID
    await CleverPush.shared.init("hxWyS7jPk4DrnSk5K", true);
  }

  void _handleSubscribe() {
    print("Prompting for Permission");
    CleverPush.shared.subscribe();
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

  void _getRemoteNotifications() async {
    bool combineWithApi = true;
    var remoteNotifications =
        await CleverPush.shared.getRemoteNotifications(combineWithApi);
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

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
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
                        "Show topics dialog", _handleTopicsDialog, true)
                  ]),
                  new TableRow(children: [
                    new CleverPushButton(
                        "Get Notifications", _getNotifications, true)
                  ]),
                  new TableRow(children: [
                    new CleverPushButton("Get Remote Notifications",
                        _getRemoteNotifications, true)
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
          )),
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
