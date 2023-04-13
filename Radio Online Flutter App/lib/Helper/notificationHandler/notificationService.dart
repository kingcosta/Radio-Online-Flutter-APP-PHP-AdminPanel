// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'awsomeNotification.dart';

class NotificationService {
  static FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  static LocalAwesomeNotification localNotification = LocalAwesomeNotification();

  static late StreamSubscription<RemoteMessage> foregroundStream;
  static late StreamSubscription<RemoteMessage> onMessageOpen;

  static requestPermission() async {}

  static init(context) {
    requestPermission();
    registerListeners(context);
  }

  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    /*
    {
        "image": "https: //radio.wrteam.in/images/notifications/1679723009.png",
        "radio_station_id": "132",
        "body": "test",
        "category": "46",
        "title": "Test",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
    }
    */

    Map<String, dynamic> data = message.data;
    if (data.containsKey("image")) {
      if (data["image"].toString().isEmpty) {
        localNotification.createNotification(isLocked: false, notificationData: message);
      } else {
        localNotification.createImageNotification(isLocked: false, notificationData: message);
      }
    } else {
      localNotification.createNotification(isLocked: false, notificationData: message);
    }
  }

  static foregroundNotificationHandler() async {
    /*
    {
        "image": "https: //radio.wrteam.in/images/notifications/1679723009.png",
        "radio_station_id": "132",
        "body": "test",
        "category": "46",
        "title": "Test",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
    }
    */

    foregroundStream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
      Map<String, dynamic> data = message.data;
      if (data.containsKey("image")) {
        if (data["image"].toString().isEmpty) {
          localNotification.createNotification(isLocked: false, notificationData: message);
        } else {
          localNotification.createImageNotification(isLocked: false, notificationData: message);
        }
      } else {
        localNotification.createNotification(isLocked: false, notificationData: message);
      }
      } catch (e) {
        print("ISSUE ${e.toString()}");
      }
    });
  }

  static terminatedStateNotificationHandler() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message == null) {
          return;
        }
        Map<String, dynamic> data = jsonDecode(message.data["data"].toString());
        if (data["image"].toString().isEmpty) {
          localNotification.createNotification(isLocked: false, notificationData: message);
        } else {
          localNotification.createImageNotification(isLocked: false, notificationData: message);
        }
      },
    );
  }

  static onTapNotificationHandler(context) {
    onMessageOpen = FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // if (message.data["screen"] == "profile") {
        //   Navigator.pushNamed(context, profileRoute);
        // }
      },
    );
  }

  static registerListeners(context) async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await foregroundNotificationHandler();
    await terminatedStateNotificationHandler();
    await onTapNotificationHandler(context);
  }

  static disposeListeners() {
    onMessageOpen.cancel();
    foregroundStream.cancel();
  }
}
