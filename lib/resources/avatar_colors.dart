import 'dart:math';
import 'package:flutter/material.dart';

class AvatarColors {
  static List<Color> _avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.pink,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.yellow,
    Colors.brown,
    Colors.grey,
  ];

  static Color getRandomColor() {
    return _avatarColors[Random().nextInt(_avatarColors.length)];
  }

  static Color getDarkColor(Color color) {
    final double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
