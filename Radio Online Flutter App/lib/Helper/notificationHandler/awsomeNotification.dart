// ignore_for_file: file_names

import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/Splash.dart';

class LocalAwesomeNotification {
  AwesomeNotifications notification = AwesomeNotifications();

  init(BuildContext context) {
    requestPermission();

    notification.initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
          channelKey: "Default",
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          ledColor: Colors.pink,
        )
      ],
      channelGroups: [],
    );
    listenTap(context);
  }

  listenTap(BuildContext context) {
    try {
      AwesomeNotifications().setListeners(
          onNotificationCreatedMethod: (receivedNotification) async {},
          onActionReceivedMethod: (ReceivedAction event) async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Splash()),
            );
          });
    } catch (e, st) {
      print(st.toString());
    }
  }

  createImageNotification({required RemoteMessage notificationData, required bool isLocked}) async {
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
    try {
      Map<String, dynamic> data = notificationData.data;
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: Colors.pink,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.BigPicture,
          body: data["body"],
          wakeUpScreen: true,
          largeIcon: data["image"],
          bigPicture: data["image"],
          channelKey: "Default",
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  createNotification({required RemoteMessage notificationData, required bool isLocked}) async {
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
    try {
      Map<String, dynamic> data = notificationData.data;
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: Colors.pink,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.Default,
          body: data["body"],
          wakeUpScreen: true,
          channelKey: "Default",
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  requestPermission() async {
    NotificationSettings notificationSettings = await FirebaseMessaging.instance.getNotificationSettings();

    if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await notification.requestPermissionToSendNotifications(
        channelKey: "Default",
        permissions: [NotificationPermission.Alert, NotificationPermission.Sound, NotificationPermission.Badge, NotificationPermission.Vibration, NotificationPermission.Light],
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized || notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {}
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
  }
}
