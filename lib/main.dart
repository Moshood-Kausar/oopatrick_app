// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oopatrick_app/data/saved_info.dart';
import 'package:oopatrick_app/screens/homepage.dart';
import 'package:oopatrick_app/screens/landingPage.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final preferences = await StreamingSharedPreferences.instance;
  final settings = MyAppSettings(preferences);
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  runApp(MyApp(settings));
}

Future<void> _onBackgroundMessage(RemoteMessage msg) async {
  print("$msg - ${msg.messageId}");
}


class MyApp extends StatelessWidget {
  final MyAppSettings settings;
  const MyApp(this.settings, {Key? key}) : super(key: key);

 

   @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
