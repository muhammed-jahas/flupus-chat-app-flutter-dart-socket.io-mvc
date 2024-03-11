import 'package:flupus/data/shared_preferences.dart';
import 'package:flupus/views/chat_list_screen.dart';
import 'package:flupus/views/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    gotoHomescreen();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              //  decoration: BoxDecoration(
              //       image: DecorationImage(image: AssetImage('assets/images/splash-background.png'),fit: BoxFit.cover)
              //     ),
              child: Center(
                child: RotationTransition(
                  turns: Tween(begin: -0.02, end: 0.02).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/flupus-bg-1.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void gotoHomescreen() async {
    String? userName = await SharedPref.instance.getUserName();
    if (userName != null) {
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ChatListScreen(),
      ));
    } else {
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
