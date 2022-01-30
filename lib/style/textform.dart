import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? icon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? secure;
  final IconData? prefixIcon;
  final String? hintText, text;
  const AppTextFormField(
      {Key? key,
      required this.controller,
      required this.text,
      required this.validator,
      this.icon,
      this.keyboardType,
      this.secure,
      this.hintText,
      this.prefixIcon,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
          child: Text(
            '$text',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color:  Color(0xff000000),
              fontSize:15
            ),
          ),
        ),
        TextFormField(
          cursorColor:  const Color(0xff5A0957),
         
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          controller: controller,
          textCapitalization: TextCapitalization.words,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 space _ / . @]")),
          ],
          validator: validator,
          obscureText: secure ?? false,
          obscuringCharacter: '◉',
          style: const TextStyle(color: Color(0xff5A0957),),
          decoration: InputDecoration(
            fillColor: const Color(0xffDCE4FF),
            filled: true,
            isDense: true,
            prefixIcon: icon ?? Icon(prefixIcon, color:  const Color(0xff5A0957),),
            contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff5A0957), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff5A0957), width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}