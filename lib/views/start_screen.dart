import 'package:flupus/components/custom_input_field.dart';
import 'package:flupus/components/custom_message.dart';
import 'package:flupus/data/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flupus/controllers/socket_controller.dart';
import 'package:flupus/views/chat_list_screen.dart';
import 'package:flupus/components/custom_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? userName = '';
  @override
  void initState() {
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/ws-bg-1.png',
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/flupus-bg-1.png',
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "👋 Hello, ${userName}!",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
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
                      Column(
                        children: [
                          CustomButton(
                            buttonText: 'Create Chat',
                            buttonFuntion: () {
                              createChatEntryAndNavigate(context);
                            },
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            buttonText: 'Join Chat',
                            buttonFuntion: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatListScreen(),
                              ));
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Let the chats begin! Get started with Flupus.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createChatEntryAndNavigate(BuildContext context) async {
    final TextEditingController _chatNameController = TextEditingController();

    final String? userName = await SharedPref.instance.getUserName();
    if (userName != null && userName.isNotEmpty) {
      // Show bottom sheet to get chatName input
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: _chatNameController,
                      borderEnabled: true,
                      hintText: 'Enter your chat name',
                      labelText: 'Chat name',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      buttonFuntion: () async {
                        String chatName = _chatNameController.text.trim();
                        if (chatName.isEmpty) {
                          CustomMessage.showError(
                              context, 'Please enter a chat name.');
                        } else if (chatName.contains(RegExp(r'[0-9]'))) {
                          CustomMessage.showError(
                              context, 'Chat name cannot contain numbers.');
                        } else {
                          // Emit event to create a chat entry with the provided chatName
                          final socket = SocketManager().socket;
                          socket.emit('createChatEntry', {
                            'chatName': chatName,
                            'createdBy': userName,
                          });
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatListScreen()),
                          );
                        }
                      },
                      buttonText: 'Create Chat',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      CustomMessage.showError(context, 'User name is not set.');
    }
  }

  fetchName() async {
    String? fetchuserName = await SharedPref.instance.getUserName();
    setState(() {
      userName = fetchuserName;
    });
  }
}
