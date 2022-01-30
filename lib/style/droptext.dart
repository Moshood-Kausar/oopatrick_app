import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  final IconData? icon;
  final String? Function(String?)? validator;
  final void Function(Object?)? onChanged;
  final String? value, hintText, text;
  final List<DropdownMenuItem<String>>? items;

  const AppDropdown({
    Key? key,
    this.validator,
    required this.text,
    this.icon,
    required this.value,
    required this.hintText,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

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
              fontWeight: FontWeight.w900,
              // color: Colors.grey.shade800,
              color: Color(0xff5A0957),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            //border: Border.all(color: grad2),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: const Color(0xffDCE4FF),
              filled: true,
              hintText: hintText,
              contentPadding: const EdgeInsets.fromLTRB(14, 16, 10, 5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xff5A0957),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xff5A0957),
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  color: Color(0xff5A0957),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            icon: Icon(icon, color: const Color(0xff5A0957),),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            items: items,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
