import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class NotificationService extends ChangeNotifier {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  doSomething(String? toto) async {
    print(toto);
  }

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings('king'));
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) => doSomething(_));
  }

  Future instantNotif(Notifications notification,
      {String extendedContext = ''}) async {
    var android = AndroidNotificationDetails("id", "channel",
        channelDescription: "description",
        color: Colors.blueGrey.shade900,
        styleInformation: const BigTextStyleInformation(''));

    var platform = NotificationDetails(android: android);
    switch (notification) {
      case Notifications.stopwatchStarted:
        {
          await flutterLocalNotificationsPlugin.show(
              0,
              'Let\'s go !',
              'The vertical kilometer Vouvry - Lake of Taney started at ${DateFormat('kk:mm:ss').format(DateTime.now())} ' +
                  extendedContext,
              platform,
              payload: Notifications.stopwatchStarted.toString());
          break;
        }
      case Notifications.stopwatchEnded:
        {
          await flutterLocalNotificationsPlugin.show(
              0,
              'Well done !',
              'The vertical kilometer Vouvry - Lake of Taney s ended at ${DateFormat('kk:mm:ss').format(DateTime.now())} ' +
                  extendedContext,
              platform,
              payload: Notifications.stopwatchEnded.toString());
          break;
        }
      default:
        {
          return;
        }
    }
  }
}

enum Notifications { stopwatchStarted, stopwatchEnded }
