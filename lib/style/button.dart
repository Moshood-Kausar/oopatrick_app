import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class MyAppButtonW extends StatelessWidget {
  final void Function() onPressed;
  final String txt;
  const MyAppButtonW({
    Key? key,
    required this.onPressed,
    required this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
         border: Border.all(color: const Color(0xff5A0957),),
        borderRadius: BorderRadius.circular(59.64),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        child: Text(
          txt,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xff5A0957),
              fontSize: 20.28),
        ),
      ),
    );
  }
}


