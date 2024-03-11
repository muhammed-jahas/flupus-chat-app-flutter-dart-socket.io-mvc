import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool borderEnabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.labelText = '',
    this.hintText = '',
    this.borderEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: borderEnabled ? OutlineInputBorder() : null,
      ),
    );
  }
}
