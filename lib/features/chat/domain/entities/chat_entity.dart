enum MessageType { text, image, audio }

class ChatMessage {
  final String role;
  final String content;
  final DateTime createdAt;
  final MessageType type;
  final String? filePath;

  ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
    this.type = MessageType.text,
    this.filePath,
  });
}
