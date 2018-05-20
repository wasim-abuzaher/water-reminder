import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/initialization_settings.dart';
import 'package:flutter_local_notifications/notification_details.dart';
import 'package:flutter_local_notifications/platform_specifics/android/initialization_settings_android.dart';
import 'package:flutter_local_notifications/platform_specifics/android/notification_details_android.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/initialization_settings_ios.dart';
import 'package:flutter_local_notifications/platform_specifics/ios/notification_details_ios.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Water Reminder',
      theme: new ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.blue,
      ),
      home: new AppState(),
    );
  }
}

class AppState extends StatefulWidget {
  @override
  createState() => new _AppState();
}

class _AppState extends State<AppState> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();

    // initialise the notification plugin
    var initializationSettingsAndroid = new InitializationSettingsAndroid('glass');
    var initializationSettingsIOS = new InitializationSettingsIOS();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);

    _repeatedNotification();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Water Reminder'),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Text(
          "We'll remind you to drink water \n "
              "every hour",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future _repeatedNotification() async {
    var androidPlatformChannelSpecifics =
    new NotificationDetailsAndroid('0',
        'Hourly', 'Notify Every 60 Minutes',
        icon: 'glass',
        sound: 'water_pour');

    var iOSPlatformChannelSpecifics = new NotificationDetailsIOS(sound: 'serving_water_slowly.aiff');

    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Water Reminder',
        "It's time to drink some water",
        RepeatInterval.Hourly,
        platformChannelSpecifics);
  }
}
