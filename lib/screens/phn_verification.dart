// // ignore_for_file: prefer_function_declarations_over_variables

// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:oopatrick_app/screens/homepage.dart';
// import 'package:pinput/pin_put/pin_put.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class PhnVerification extends StatefulWidget {
//   final String phn, fname;
//   const PhnVerification({Key? key, required this.phn, required this.fname})
//       : super(key: key);

//   @override
//   _PhnVerificationState createState() => _PhnVerificationState();
// }

// class _PhnVerificationState extends State<PhnVerification> {
//   DatabaseReference db = FirebaseDatabase.instance.reference().child("Users");
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? user;
//   String _verificationId = '';
//   TextEditingController? _pinPutController;
//   final FocusNode _pinPutFocusNode = FocusNode();

//   BoxDecoration get _pinPutDecoration {
//     return BoxDecoration(
//       border: Border.all(color: Colors.green),
//       borderRadius: BorderRadius.circular(15),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _auth.userChanges().listen((event) => setState(() => user = event));
//     _verifyPhoneNumber(_auth, "+234${widget.phn}");
//     Future.delayed(const Duration(seconds: 1), () {
//       showToast('Sending OTP to ' + widget.phn.replaceRange(0, 7, '*******'));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 100),
//                   Text(
//                     "Hello " "${widget.fname}!",
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const Text(
//                     'To reduce spam account on our system, we need you to verify your phone number to continue using our platform. Thanks',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                   const SizedBox(height: 40),
//                   Row(
//                     children: [
//                       Text('Enter OTP sent to ' +
//                           widget.phn.replaceRange(0, 7, '*******')),
//                     ],
//                   ),
//                   PinPut(
//                     fieldsCount: 6,
//                     autofocus: true,
//                     focusNode: _pinPutFocusNode,
//                     controller: _pinPutController,
//                     submittedFieldDecoration: _pinPutDecoration.copyWith(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     onChanged: (value) async {
//                       if (value.length == 6) {
//                         signInWithPhoneNumber(_verificationId, value);
//                       }
//                     },
//                     selectedFieldDecoration: _pinPutDecoration,
//                     followingFieldDecoration: _pinPutDecoration.copyWith(
//                       borderRadius: BorderRadius.circular(10.0),
//                       border: Border.all(
//                         color: const Color(0xff5A0957),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   showSnackBar(String text) {
//     ScaffoldMessenger.of(context).showMaterialBanner(
//       MaterialBanner(
//         content: Text(text),
//         contentTextStyle: const TextStyle(color: Colors.white),
//         backgroundColor: Colors.black,
        
//         actions: [
//           TextButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
//             },
//             child: const Text('Dismiss'),
//           ),
//         ],
//       ),
//     );
//   }

//   showToast(String msg) {
//     Fluttertoast.showToast(
//       msg: msg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   Future<void> _verifyPhoneNumber(FirebaseAuth auth, String phoneNumber) async {
//     verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
//       db.child(_auth.currentUser!.uid).update({
//         "phnVerified": true,
//       }).then(
//         (value) => Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomePage(),
//           ),
//         ),
//       );
//     }

    
//     verificationFailed(FirebaseAuthException authException) {
//       showSnackBar(
//           'verification failed: ${authException.code}. Message: ${authException.message}');
//       debugPrint(
//           'verification failed: ${authException.code}. Message: ${authException.message}');
//     }

//     //call if code sent successfully
//     codeSent(String verificationId, [int? forceResendingToken]) async {
//       showSnackBar('OTP sent ' + widget.phn.replaceRange(0, 7, '*******'));
//       setState(() {
//         _verificationId = verificationId;
//       });
//       Timer(
//         const Duration(milliseconds: 400),
//         () => ScaffoldMessenger.of(context).removeCurrentMaterialBanner(),
//       );
//     }

//     codeAutoRetrievalTimeout(String verificationId) {
//       verificationId = verificationId;
//       setState(() {
//         verificationId = _verificationId;
//       });
//     }

//     //call to start verification process
//     try {
//       await auth.verifyPhoneNumber(
//         phoneNumber: "+234${widget.phn}",
//         //"+234${phoneNumber.substring(1)}", //remove first '0' from phone no
//         timeout: const Duration(seconds: 10),
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//       );
//     } catch (e) {
//       showSnackBar('$e');
//       debugPrint("Failed to Verify Phone Number: $e **************");
//     }
//   }

//   Future<void> signInWithPhoneNumber(String verificationId, String sms) async {
//     try {
//       PhoneAuthProvider.credential(
//           verificationId: verificationId, smsCode: sms);
//       // showSnackBar('Verification successful, proceed to dashboard');
//       db.child(_auth.currentUser!.uid).update({
//         "phnVerified": true,
//       }).then(
//         (value) => Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomePage(),
//           ),
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       //catch firebase verificaton error
//       showSnackBar("${e.message}");
//       debugPrint("Failed to Verify Phone Number: ${e.message} ***************");
//     }
//   }
// }

// class Fire {
//   /// this method send sms to phone no and try to automatically verify phone no
//   static Future<void> verifyPhoneNumber(
//       BuildContext context, FirebaseAuth auth, String phoneNumber) async {
//     /// this check if phone no automatically verified
//     var verificationCompleted =
//         (PhoneAuthCredential phoneAuthCredential) async {
//       await auth.signInWithCredential(phoneAuthCredential);

//       /// what to do if phone no automatically verified
//       /// probably go to dashboard or anything here
//       debugPrint("Phone No automatically verified, proceed to dashboard");
//       debugPrint("Phone No automatically verified, proceed to dashboard");
//     };

//     //display if unable to verify phone no
//     PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException authException) {
//       /// what to do if verification failed
//       /// propably display error snackbar
//       debugPrint(
//           'verification failed: ${authException.code}. Message: ${authException.message}');
//       debugPrint(
//           'verification failed: ${authException.code}. Message: ${authException.message}');
//     };

//     //call if code sent successfully
//     PhoneCodeSent codeSent =
//         (String verificationId, [int? forceResendingToken]) async {
//       /// what to do if code was successfully sent to phone no
//       /// probably proceed to verification page
//       /// and send [verificationId] to verification page
//       print('Please check your phone for the verification code.');
//       print('Please check your phone for the verification code.');
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //       builder: (context) =>
//       //           VerificationPage(verificationId: verificationId)),
//       // );
//     };

//     PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//         (String verificationId) {
//       verificationId = verificationId;
//     };

//     //call to start verification process
//     try {
//       await auth
//           .verifyPhoneNumber(
//               phoneNumber: "+23409063484529",
//               // "+234${phoneNumber.substring(1)}", //remove first '0' from phone no
//               timeout: const Duration(seconds: 5),
//               verificationCompleted: verificationCompleted,
//               verificationFailed: verificationFailed,
//               codeSent: codeSent,
//               codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
//           .then(
//             (value) => print('Verification successful'),
//           );
//     } catch (e) {
//       print("Failed to Verify Phone Number: $e");
//     }
//   }

//   /// this method accept [verificationId] sent from registration page
//   /// and [sms] from phone as parameters
//   static Future<void> signInWithPhoneNumber(
//       FirebaseAuth auth, String verificationId, String sms) async {
//     try {
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: sms,
//       );
//       (await auth.signInWithCredential(credential)).user;

//       /// what to do if verification is successful
//       /// probably go to dashboard
//       print('Verification successful, proceed to dashboard');
//       print("Phone Not verified, proceed to dashboard");
//     } catch (e) {
//       //catch firebase verificaton error
//       print("Failed to Verify Phone Number: $e");
//     }
//   }
// }
