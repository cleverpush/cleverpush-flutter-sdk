import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cleverpush_flutter/cleverpush_flutter.dart';

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

    CleverPush.shared.setNotificationReceivedHandler((CPNotificationReceivedResult result) {
      this.setState(() {
        _debugLabelString =
            "Notification received: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    CleverPush.shared.setNotificationOpenedHandler((CPNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Notification opened: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    CleverPush.shared.setSubscribedHandler((subscriptionId) {
      this.setState(() {
        _debugLabelString = "Subscribed: " + subscriptionId;
      });

      print("Subscribed: ${subscriptionId}");
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
          new FlatButton(
            disabledColor: Color.fromARGB(100, 100, 100, 100),
            disabledTextColor: Colors.white,
            color: Color.fromARGB(255, 33, 33, 33),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
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
