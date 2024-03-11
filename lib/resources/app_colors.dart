import 'package:flutter/material.dart';

class AppColors {
  static const int _primaryValue =
      0xFFEE4711; // Updated with the new primary color

  static const MaterialColor primaryColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFFFF0E6), // lighter shade
      100: Color(0xFFFFCC99),
      200: Color(0xFFFFA366),
      300: Color(0xFFFF7A33),
      400: Color(0xFFFF6600),
      500: Color(_primaryValue), // primary color
      600: Color(0xFFCC3D00),
      700: Color(0xFFB33300),
      800: Color(0xFF992900),
      900: Color(0xFF7A1A00), // darker shade
    },
  );

  static const Color alertColor = Color(0xFFE01B1B);
  static const Color secondaryColor = Color(0xFF0E403D);
  static const Color yellowColor = Color(0xFFDBFF00);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFFF2F6FF);
  static const Color scaffoldBackgroundColor = Color(0xFF1C1C1C);
  static const Color appBarColor1 = Color(0xFF242424);
  static const Color borderColor = Color(0xFF3A3A3A);
  static const Color chatBubble1 = Color(0xFF3D261F);
  // static const Color accentColor = Color(0xFF9C27B0);
  // static const Color textColor = Color(0xFF333333);
}
