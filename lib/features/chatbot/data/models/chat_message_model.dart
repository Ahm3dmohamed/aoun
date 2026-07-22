import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';

/// Data model for ChatMessage with JSON serialization.
/// Handles API response shapes from both /send and /history endpoints.
class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.message,
    required super.sender,
    required super.timestamp,
    super.isError,
    super.isLoading,
  });

  /// Parses a single message object from the API.
  /// Flexible parsing to handle various server response shapes.
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Parse sender — server may use 'user'/'ai', 'user'/'bot', 'user'/'assistant'
    final rawSender = (json['sender'] ?? json['role'] ?? 'ai').toString().toLowerCase();
    final normalizedSender = (rawSender == 'user') ? 'user' : 'ai';

    // Parse timestamp — ISO string or epoch int
    DateTime timestamp;
    final rawTs = json['timestamp'] ?? json['created_at'] ?? json['createdAt'];
    if (rawTs == null) {
      timestamp = DateTime.now();
    } else if (rawTs is int) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(rawTs);
    } else {
      timestamp = DateTime.tryParse(rawTs.toString()) ?? DateTime.now();
    }

    // Parse message content
    final content = (json['message'] ?? json['content'] ?? json['text'] ?? '').toString();

    // Parse ID
    final id = (json['id'] ?? json['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString()).toString();

    return ChatMessageModel(
      id: id,
      message: content,
      sender: normalizedSender,
      timestamp: timestamp,
      isError: json['isError'] == true,
    );
  }

  /// Serializes a message to JSON for local Hive storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
    };
  }

  /// Creates a model from a domain entity (for caching).
  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      message: entity.message,
      sender: entity.sender,
      timestamp: entity.timestamp,
      isError: entity.isError,
      isLoading: entity.isLoading,
    );
  }

  /// Creates a model from Hive local storage map.
  factory ChatMessageModel.fromLocalJson(Map<dynamic, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      sender: json['sender']?.toString() ?? 'ai',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
      isError: json['isError'] == true,
    );
  }
}
