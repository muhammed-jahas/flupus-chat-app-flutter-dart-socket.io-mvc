import 'package:flupus/components/custom_chat_message.dart';
import 'package:flupus/controllers/socket_controller.dart';
import 'package:flupus/data/shared_preferences.dart';
import 'package:flupus/models/chat_entry.dart';
import 'package:flupus/models/chat_message_model.dart';
import 'package:flupus/resources/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String chatEntryId;
  final ChatEntry chat;

  ChatScreen({required this.chatEntryId, required this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> messages = [];
  String username = '';
  bool showEmojiPicker = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetchUserName();
    socket = SocketManager().socket;
    socket.emit('joinChatRoom', {'chatEntryId': widget.chatEntryId});
    socket.emit('loadMessages', {'chatEntryId': widget.chatEntryId});
    socket.on('message', handleMessage);
    socket.on('loadMessages', handleLoadMessages);
  }

  void handleMessage(dynamic data) {
    print('Received message: $data');
    if (data is Map<String, dynamic>) {
      final message = ChatMessage.fromJson(data);
      if (mounted) {
        setState(() {
          messages.add(message);
          // Scroll to the bottom when a new message is added
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 500,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }
  }

  void handleLoadMessages(dynamic data) {
    print('Received loadMessages: $data');
    if (data is List) {
      List<ChatMessage> loadedMessages =
          data.map((item) => ChatMessage.fromJson(item)).toList();
      if (mounted) {
        setState(() {
          messages.clear(); // Clear existing messages
          messages.addAll(loadedMessages);
        });
      }
    }
  }

  void fetchUserName() async {
    String? fetchname = await SharedPref.instance.getUserName();
    String userName = fetchname ?? '';
    if (mounted) {
      setState(() {
        username = userName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showEmojiPicker) {
          setState(() {
            showEmojiPicker = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.chat.chatName}'),
          backgroundColor: AppColors.appBarColor1,
          surfaceTintColor: AppColors.appBarColor1,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                separatorBuilder: (context, index) => SizedBox(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return CustomChatMessage(message: messages[index]);
                },
              ),
            ),
            Container(
              color: AppColors.appBarColor1,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        showEmojiPicker = !showEmojiPicker;
                      });
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 20,
                      style: TextStyle(),
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your message',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.send_outlined,
                        size: 16,
                      ),
                    ),
                    onPressed: () {
                      socket.emit('message', {
                        'message': messageController.text,
                        'sender': username,
                        'time': DateTime.now().toIso8601String(),
                        'chatEntryId': widget.chatEntryId,
                        'isUser': true,
                      });
                      messageController.clear();
                    },
                  ),
                ],
              ),
            ),
            if (showEmojiPicker)
              EmojiPicker(
                config: Config(
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: Colors.grey.shade900,
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: Colors.grey.shade900,
                    buttonColor: AppColors.primaryColor,
                    enabled: false,
                  ),
                  emojiViewConfig: EmojiViewConfig(
                    backgroundColor: Colors.black26,
                    gridPadding: EdgeInsets.all(4),
                    horizontalSpacing: 6,
                    columns: 8,
                  ),
                  skinToneConfig: SkinToneConfig(
                    dialogBackgroundColor: Colors.black12,
                  ),
                ),
                // Emoji picker configuration
                onEmojiSelected: (category, emoji) {
                  // Replace the hint text with the selected emoji
                  setState(() {
                    messageController.text += emoji.emoji;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
