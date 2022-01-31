import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DatabaseReference db = FirebaseDatabase.instance.reference().child("Users");

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      db.child(user!.uid).set({
        "uid": user.uid,
        "email": user.email,
        "fname": user.displayName,
        "pic": user.photoURL,
      }).then((value) {
        debugPrint('Information saved to database');
      });

      debugPrint('signInWithGoogle succeeded: $user');
      return 'signInWithGoogle succeeded: $user';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    debugPrint('User signed out!');
  }
}
