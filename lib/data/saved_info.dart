

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : uid = preferences.getString('uid', defaultValue: ''),
        location = preferences.getString('location', defaultValue: ''),
        isVerified = preferences.getBool('isVerified', defaultValue: false),
        phoneNo = preferences.getString('phoneNumber', defaultValue: ''),
        lastName = preferences.getString('lastName', defaultValue: ''),
        gender = preferences.getString('gender', defaultValue: ''),
        email = preferences.getString('email', defaultValue: ''),
        role = preferences.getString('role', defaultValue: ''),
        firstName = preferences.getString('firstName', defaultValue: '');

  final Preference<String> uid;
  final Preference<String> location;
  final Preference<bool> isVerified;
  final Preference<String> phoneNo;
  final Preference<String> lastName;
  final Preference<String> gender;
  final Preference<String> email;
  final Preference<String> role;
  final Preference<String> firstName;
}
