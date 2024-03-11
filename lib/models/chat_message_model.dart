class ChatMessage {
  final String message;
  final String sender;
  final DateTime time;
  bool isUser; // Updated isUser field

  ChatMessage({
    required this.message,
    required this.sender,
    required this.time,
    this.isUser = false, // Default value is false
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      sender: json['sender'] ?? '',
      time: DateTime.parse(json['time'] ?? ''),
      isUser: json['isUser'] ?? false,
    );
  }
}
