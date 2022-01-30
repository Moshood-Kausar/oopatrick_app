import 'package:flutter/material.dart';
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
<<<<<<< HEAD
    print(
        'Info Saved **************** $role, $lname, $fname, $uid ************');
=======
    debugPrint('Infor Saved *** $lname, $fname, $uid ******');
>>>>>>> eab23671ed97816af74075cf6997b81e2b9a1744
  }
}
