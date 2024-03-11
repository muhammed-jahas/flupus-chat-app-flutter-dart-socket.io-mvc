import 'package:flupus/components/custom_button.dart';
import 'package:flupus/components/custom_input_field.dart';
import 'package:flupus/data/shared_preferences.dart';
import 'package:flupus/views/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/ws-bg-1.png',
                  ),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .3,
                        child: SvgPicture.asset(
                          'assets/images/chat-bubble.svg',
                        ),
                      ),
                      RotationTransition(
                        turns: Tween(begin: -0.02, end: 0.02).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/flupus-bg-1.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "👋 Say hello to Flupus,\n your new chat buddy.",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Let the chats begin! Get started with Flupus.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            buttonText: 'Get Started',
                            buttonFuntion: () {
                              collectName(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  collectName(BuildContext context) async {
    // Show bottom sheet to get chatName input
    final TextEditingController _nameController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    borderEnabled:
                        true, // You can toggle this to show/hide the border
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    buttonText: "Let's go",
                    buttonFuntion: () {
                      storeName(_nameController.text);
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => StartScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  storeName(String name) {
    SharedPref.instance.sharedPref.setString(SharedPref.userName, name);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
