import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class CustomMessage {
  static void showError(BuildContext context, String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  static void showInfo(BuildContext context, String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
