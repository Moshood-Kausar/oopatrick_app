import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oopatrick_app/data/my_function.dart';
import 'package:oopatrick_app/screens/homepage.dart';
import 'package:oopatrick_app/style/button.dart';
import 'package:oopatrick_app/style/droptext.dart';
import 'package:oopatrick_app/style/textform.dart';
import 'login.dart';
import "package:oopatrick_app/data/firebase_service.dart";

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseService service = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  DatabaseReference db = FirebaseDatabase.instance.reference().child("Users");

  int? selectedIndex;
  String? _gender;
  List<String>? genders;
  TextEditingController? _lastname,
      _firstname,
      _email,
      _phone,
      _password,
      _location,
      _passwordd;

  //FocusNode? pass;
  //String? email;
  bool _hideShow = true;
  bool _hideshoww = true;
  bool isLoading = false, btnLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const Login()));
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
                  "Sign-Up",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2A212A),
                  ),
                ),
                AppTextFormField(
                  controller: _firstname,
                  secure: false,
                  text: 'First Name',
                  icon: const Icon(
                    Icons.account_circle_sharp,
                    color: Color(0xff5A0957),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty field detected';
                    } else if (value.length < 2) {
                      return 'Firstname cannot be less than 3 characters';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                AppTextFormField(
                  controller: _lastname,
                  secure: false,
                  text: 'Last Name',
                  icon: const Icon(
                    Icons.account_circle_rounded,
                    color: Color(0xff5A0957),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty field detected';
                    } else if (value.length < 2) {
                      return 'Lastname cannot be less than 3 characters';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: AppTextFormField(
                        controller: _phone,
                        secure: false,
                        text: 'Phone',
                        keyboardType: TextInputType.number,
                        icon: const Icon(
                          Icons.phone,
                          color: Color(0xff5A0957),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty field detected';
                          } else if (value.length < 11) {
                            return 'Number cannot be less than 11 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 4,
                      child: AppDropdown(
                        text: 'Gender',
                        icon: Icons.keyboard_arrow_down,
                        value: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value as String?;
                            selectedIndex = genders!.indexOf(value!);
                          });
                        },
                        items: genders!.map((val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: const Color(0xff5A0957),
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Gender not selected';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Select Gender',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                AppTextFormField(
                  controller: _email,
                  secure: false,
                  text: 'Email',
                  icon: const Icon(
                    Icons.email,
                    color: Color(0xff5A0957),
                  ),
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
                  controller: _location,
                  secure: false,
                  text: 'Location',
                  icon: const Icon(
                    Icons.location_city_outlined,
                    color: Color(0xff5A0957),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Empty field detected';
                    } else if (value.length < 2) {
                      return 'Location cannot be less than 3 characters';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextFormField(
                        controller: _password,
                        secure: _hideShow,
                        text: 'Password',
                        hintText: '••••••••',
                        textInputAction: TextInputAction.next,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hideShow = !_hideShow;
                            });
                          },
                          icon: Icon(
                            _hideShow ? Icons.lock : Icons.lock_open,
                            color: const Color(0xff5A0957),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty field detected';
                          } else if (value.length < 6) {
                            return '6 characters or more required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: AppTextFormField(
                        controller: _passwordd,
                        secure: _hideshoww,
                        text: 'Confirm Password',
                        hintText: '••••••••',
                        textInputAction: TextInputAction.done,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hideshoww = !_hideshoww;
                            });
                          },
                          icon: Icon(_hideshoww ? Icons.lock : Icons.lock_open,
                              color: const Color(0xff5A0957)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty field detected';
                          } else if (value != _password!.text) {
                            return "Password doesn't match";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                !btnLoad
                    ? MyAppButtonW(
                        txt: "SIGN UP",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              btnLoad = true;
                            });
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _email!.text.trim(),
                                      password: _password!.text)
                                  .then((value) {
                                db.child(value.user!.uid).set({
                                  "uid": value.user!.uid,
                                  "Lastname": _lastname!.text,
                                  "Firstname": _firstname!.text,
                                  "Email": _email!.text.trim(),
                                  "Phone": _phone!.text,
                                  "Location": _location!.text,
                                  "Gender": _gender,
                                  "role": 'customer',
                                  "phnVerified": false,
                                }).then((res) async {
                                  getUserInfo(uid: value.user!.uid);
                                });
                              }).timeout(timeOut);
                            } on SocketException catch (_) {
                              snackBar(nointernet);
                            } on TimeoutException catch (_) {
                              snackBar(timeMsg);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                snackBar(
                                    'The email address is already in use by another account.');
                                debugPrint(e.message);
                              } else {
                                snackBar('${e.message}');
                              }
                            }
                            setState(() {
                              btnLoad = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ));
                            });
                          }
                        },
                      )
                    : const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                          ),
                        ),
                      ),
                !isLoading
                    ? TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await service.signInwithGoogle().then(
                              (value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                            ).timeout(timeOut);
                            debugPrint(
                                'Sign in with Google completed - navigate to home screen');
                          } on SocketException catch (_) {
                            snackBar(nointernet);
                          } on TimeoutException catch (_) {
                            snackBar(timeMsg);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              snackBar(
                                  'The email address is already in use by another account.');
                              debugPrint(e.message);
                            } else {
                              snackBar('${e.message}');
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text('Sign up with google',
                            style: TextStyle( color:  Color(0xff5A0957),)),
                      )
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                        ),
                      ),
                const SizedBox(height: 40),
                Text(
                  'Already have an account?',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xff5A0957),
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
              isVerified: v.value['phnVerified'],
            );
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
      btnLoad = true;
    });
  }

  _stopLoading() {
    setState(() {
      btnLoad = false;
    });
  }

  snackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    ));
  }

  @override
  void initState() {
    super.initState();
    _lastname = TextEditingController();
    _firstname = TextEditingController();
    _location = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _password = TextEditingController();
    _passwordd = TextEditingController();
    genders = [
      'Male',
      'Female',
    ];
  }

  @override
  void dispose() {
    _firstname!.dispose();
    _lastname!.dispose();
    _location!.dispose();
    _phone!.dispose();
    _email!.dispose();
    _password!.dispose();
    _passwordd!.dispose();
    super.dispose();
  }
}

const Duration timeOut = Duration(seconds: 30);
const String timeMsg = 'Request timeout. Kindly try again';
const String nointernet = 'No active internet connection, Kindly try again!';
