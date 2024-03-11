import 'package:flupus/models/chat_message_model.dart';
import 'package:flupus/resources/app_colors.dart';
import 'package:flupus/resources/avatar_colors.dart';
import 'package:flupus/views/chat_screen.dart';
import 'package:flupus/views/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flupus/controllers/socket_controller.dart';
import 'package:flupus/models/chat_entry.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late IO.Socket socket;
  List<ChatEntry> chatEntries = [];

  @override
  void initState() {
    super.initState();
    socket = SocketManager().socket;
    socket.emit('loadChatEntries');
    socket.on('chatEntries', handleLoadChatEntries);
    socket.on('newChatEntry', handleNewChatEntry);
  }

  void handleLoadChatEntries(dynamic data) {
    print('Received chatEntries: $data');
    if (data is List) {
      setState(() {
        chatEntries = data.map((item) {
          var entry = ChatEntry.fromJson(item);
          entry.messages = []; // Initialize messages list
          if (item['messages'] != null) {
            entry.messages = List<ChatMessage>.from(
                item['messages'].map((x) => ChatMessage.fromJson(x)));
          }
          return entry;
        }).toList();
      });
    }
  }

  void handleNewChatEntry(dynamic data) {
    print('Received new chat entry: $data');
    if (data is List) {
      setState(() {
        chatEntries.addAll(data.map((item) {
          var entry = ChatEntry.fromJson(item);
          entry.messages = []; // Initialize messages list
          if (item['messages'] != null) {
            entry.messages = List<ChatMessage>.from(
                item['messages'].map((x) => ChatMessage.fromJson(x)));
          }
          return entry;
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text('Flupus',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        child: Icon(Icons.add_comment_rounded),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => StartScreen(),
          ));
        },
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(top: 20),
        itemCount: chatEntries.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            color: Colors.grey.withOpacity(.2),
            thickness: 0.4,
          );
        },
        itemBuilder: (context, index) {
          // Get the chat entry in reversed order
          ChatEntry chatEntry = chatEntries.reversed.toList()[index];

          String firstLetter = chatEntry.chatName.isNotEmpty
              ? chatEntry.chatName.substring(0, 1).toUpperCase()
              : '';
          String totalMessages = chatEntry.messages.length.toString();
          Color randomColor = AvatarColors.getRandomColor();
          Color darkColor = AvatarColors.getDarkColor(randomColor);

          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: randomColor,
              child: Text(
                firstLetter,
                style: TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(chatEntry.chatName),
            subtitle: Text(
              'Created by: ${chatEntry.createdBy}',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            trailing: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor.withOpacity(.07),
              child: Text(
                '${totalMessages}',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatEntryId: chatEntry.id,
                  chat: chatEntry,
                ),
              ));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Disconnect listeners
    socket.off('chatEntries', handleLoadChatEntries);
    socket.off('newChatEntry', handleNewChatEntry);
    super.dispose();
  }
}
