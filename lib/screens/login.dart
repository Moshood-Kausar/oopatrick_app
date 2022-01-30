import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oopatrick_app/data/my_function.dart';
import 'package:oopatrick_app/screens/landing_page.dart';
import 'package:oopatrick_app/screens/sign_up.dart';
import 'package:oopatrick_app/style/button.dart';
import 'package:oopatrick_app/style/textform.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _email, _password;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LandingPage()));
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                        Text(
                          'CLOSE',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: const Color(0xff5A0957),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2A212A),
                      ),
                    ),
                    const SizedBox(height: 38),
                    SvgPicture.asset(
                      'assets/login.svg',
                      height: 200,
                    ),
                    const SizedBox(height: 40),
                    AppTextFormField(
                      controller: _email,
                      text: 'Email ',
                      prefixIcon: Icons.email,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty field detected';
                        } else if (value.length < 6) {
                          return 'email cannot be less than 6 characters';
                        } else if (!value.contains('@')) {
                          return 'Invalid email address entered';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    AppTextFormField(
                      controller: _password,
                      secure: true,
                      text: 'Password',
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty field detected';
                        } else if (value.length < 6) {
                          return 'password cannot be less than 6 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Forgot Password ?',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: const Color(0xff5A0957),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            ),
                          )
                        : MyAppButtonW(
                            txt: 'LOGIN',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _email!.text.trim(),
                                          password: _password!.text)
                                      .then(
                                    (value) {
                                      _isLoading = false;
                                      getUserInfo(uid: value.user!.uid);
                                    },
                                  ).timeout(timeOut);
                                } on SocketException catch (_) {
                                  snackBar(nointernet);
                                } on TimeoutException catch (_) {
                                  snackBar(timeMsg);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    snackBar('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    snackBar(
                                        'Wrong password provided for that user.');
                                  } else {
                                    snackBar('${e.message}');
                                  }
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUp(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account?  ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black),
                          children: const [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: Color(0xff5A0957)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getUserInfo({required String uid}) async {
    final db = FirebaseDatabase.instance.reference().child("Users");
    Future<DataSnapshot>? _users;
    _users = db.child(uid).once();
    _startLoading();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future<DataSnapshot> auth = _users;
        auth.then((v) {
          if (v.exists == true) {
            _stopLoading();
            MyFunctions().saveUserInfo(
                uid: uid,
                role: v.value['role'],
                fname: v.value['Firstname'],
                lname: v.value['Lastname'],
                phn: v.value['Phone'],
                email: v.value['Email'],
                gender: v.value['Gender'],
                location: v.value['Location'],
                isVerified: v.value['phnVerified']);
            snackBar('Info saved 😎');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            _stopLoading();
            snackBar('An error occured, kindly try again');
          }
        }).timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            _stopLoading();
            snackBar('Timeout message');
          },
        );
      } else {
        _stopLoading();
        snackBar('No internet connection');
      }
    } on SocketException catch (_) {
      _stopLoading();
      snackBar('No internet connection');
    }
  }

  _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  snackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    ));
  }
}
