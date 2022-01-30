// ignore_for_file: avoid_print

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyFunctions {
  saveUserInfo({
    required String uid,
    required String role,
    required String fname,
    required String lname,
    required String phn,
    required String email,
    required String location,
    required String gender,
    required bool isVerified,
  }) async {
    final prefs = await StreamingSharedPreferences.instance;
    prefs.setString('uid', uid);
    prefs.setString('location', location);
    prefs.setBool('isVerified', isVerified);
    prefs.setString('phoneNumber', phn);
    prefs.setString('lastName', lname);
    prefs.setString('firstName', fname);
    prefs.setString('gender', gender);
    prefs.setString('email', email);

    prefs.setString('role', role);
    print(
        'Info Saved **************** $role, $lname, $fname, $uid ************');
  }
}
