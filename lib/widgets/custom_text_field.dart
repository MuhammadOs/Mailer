import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hint,
    this.maxLines = 1,
    this.onSaved,
    this.onChanged,
    required this.color,
    this.controller,
    this.obscureText = false,
    this.initialValue,
    this.suffixIcon,
  }) : super(key: key);

  final String hint;
  final int maxLines;
  final Color color;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialValue;
  final IconButton? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onSaved: onSaved,
        onChanged: onChanged,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Field is required";
          } else {
            return null;
          }
        },
        cursorColor: Colors.white,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: color),
          border: buildBorder(),
          fillColor: const Color(0xff005599),
          filled: true,
          focusColor: const Color(0xff005599),
          hoverColor: const Color(0xff005599),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(color),
          suffixIcon: suffixIcon,
        ),
        initialValue: initialValue,
      ),
    );
  }

  OutlineInputBorder buildBorder([color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
