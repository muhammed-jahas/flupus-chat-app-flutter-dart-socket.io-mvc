import 'package:flupus/data/shared_preferences.dart';
import 'package:flupus/models/chat_message_model.dart';
import 'package:flupus/resources/app_colors.dart';
import 'package:flupus/resources/avatar_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CustomChatMessage extends StatefulWidget {
  final ChatMessage message;

  CustomChatMessage({required this.message});

  @override
  State<CustomChatMessage> createState() => _CustomChatMessageState();
}

class _CustomChatMessageState extends State<CustomChatMessage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    String? fetchname = await SharedPref.instance.getUserName();
    setState(() {
      username = fetchname ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor = AvatarColors.getRandomColor();
    Color darkColor = AvatarColors.getDarkColor(randomColor);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: widget.message.sender == username
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.message.sender == username
                  ? SizedBox()
                  : CircleAvatar(
                      radius: 14,
                      backgroundColor: randomColor,
                      child: Text(
                        style: TextStyle(color: darkColor, fontSize: 10),
                        (widget.message.sender.isNotEmpty
                            ? widget.message.sender
                                .substring(0, 1)
                                .toUpperCase()
                            : 'A'),
                      )),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: widget.message.sender == username
                        ? BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                    color: widget.message.sender == username
                        ? const Color.fromARGB(255, 42, 42, 42)
                        : const Color.fromARGB(255, 42, 42, 42)),
                padding: EdgeInsets.only(
                  right: 20,
                  left: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.message.sender != username)
                      Text(
                        "${widget.message.sender.isNotEmpty ? '${widget.message.sender.substring(0, 1).toUpperCase()}${widget.message.sender.substring(1)}' : 'User'}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: randomColor,
                        ),
                      ),
                    SizedBox(height: 2),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: Text(
                        widget.message.message,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${DateFormat('h:mm a').format(widget.message.time.toLocal())}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
