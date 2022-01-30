import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oopatrick_app/screens/sign_up.dart';
import 'package:oopatrick_app/style/button.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  "assets/oop.svg",
                  width: 80,
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
            SvgPicture.asset(
              "assets/landing.svg",
              height:400,
            ),
            const SizedBox(height: 40),
            MyAppButtonW(
              txt: 'SIGN IN',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const Login(),
                  ),
                );
              },
            ),
            const SizedBox(height: 23.86),
            MyAppButtonW(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SignUp(),
                    ),
                  );
                },
                txt: 'SIGN UP'),
            const SizedBox(height: 48.86),
          ],
        ),
      ),
    );
  }
}
