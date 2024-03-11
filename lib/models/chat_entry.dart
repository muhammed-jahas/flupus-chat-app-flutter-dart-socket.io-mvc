import 'package:flupus/models/chat_message_model.dart';

class ChatEntry {
  final String id;
  final String chatName;
  final String createdBy;
  List<ChatMessage> messages; // Added field for messages

  ChatEntry({
    required this.id,
    required this.chatName,
    required this.createdBy,
    required this.messages,
  });

  factory ChatEntry.fromJson(Map<String, dynamic> json) {
    // Parse messages from JSON
    List<ChatMessage> messages = [];
    if (json['messages'] != null) {
      messages = List<ChatMessage>.from(
          json['messages'].map((x) => ChatMessage.fromJson(x)));
    }

    return ChatEntry(
      id: json['_id'] ?? '',
      chatName: json['chatName'] ?? '',
      createdBy: json['createdBy'] ?? '',
      messages: messages,
    );
  }
}
