import 'package:flupus/data/shared_preferences.dart';
import 'package:flupus/resources/app_colors.dart';
import 'package:flupus/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.instance.initStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'sofia',
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.appBarColor1, elevation: 0),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
