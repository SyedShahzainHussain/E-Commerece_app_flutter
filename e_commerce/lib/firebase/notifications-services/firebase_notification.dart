import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // * checking user give the notification permission or not
  void requestNotifiactionService() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    //* for android
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
     
    }
    //* for ios
    else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("Granted by provisional");
      }
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  // * getDeviceToken
  Future<String> getDevicesToken() async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }

  // * token refresh if token expired
  void resetTokenIfExpire() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // * initialization the android an ios application
  void initializationNotification(
      BuildContext context, RemoteMessage message) async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const DarwinInitializationSettings();

    var initialization = InitializationSettings(android: android, iOS: ios);
    localNotificationsPlugin.initialize(
      initialization,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  // * show the notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "High Importance Notification",
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound(
          'android_app_src_main_res_raw_jetsons_doorbell'),
      playSound: true,
      showBadge: true,
      
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      playSound: true,
      sound: channel.sound,

    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      localNotificationsPlugin.show(0, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }

  // * listen the notification
  void FirebaseInIt(BuildContext context) {
    
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initializationNotification(context, message);
        showNotification(message);
      }
    });
  }

 

}
