import 'package:brew_cew/screens/wrapper.dart';
import 'package:brew_cew/services/auth.dart';
import 'package:brew_cew/services/local_notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//rexeive message when app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);

    //gives you the message on whuch user taps
    //and it opend the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // when the app is closed and user clicked on the notification

      print(message!.data["routePage"]);
    });
    //on forground only
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.body);
      print(message.notification!.title);
      LocalNotificationService.display(message);
    });
    //when user tap on the notification and the app should be in the back ground  state
    ///
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("hereee");
      if (message.data != null) {
        print(message.data["routePage"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
