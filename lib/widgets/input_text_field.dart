import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  const InputTextField(
      {super.key, required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: text == "Password",
      controller: controller,
      style: const TextStyle(color: white),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
