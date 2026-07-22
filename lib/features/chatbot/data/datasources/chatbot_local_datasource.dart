import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/chatbot/data/models/chat_message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source for caching chatbot messages using Hive.
/// Uses the already-opened 'chatBox' from main.dart.
class ChatbotLocalDatasource {
  static const String _messagesKey = 'chatbot_messages';

  Box get _box => Hive.box('chatBox');

  /// Load all cached messages from local storage.
  List<ChatMessageModel> loadMessages() {
    try {
      final raw = _box.get(_messagesKey, defaultValue: <dynamic>[]);
      final list = List<dynamic>.from(raw as List);
      return list
          .map((item) => ChatMessageModel.fromLocalJson(Map<dynamic, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      // Return empty list on any parse error — prefer fresh fetch over crash
      return [];
    }
  }

  /// Persist the full list of messages (replaces existing cache).
  Future<void> saveMessages(List<ChatMessageModel> messages) async {
    try {
      final jsonList = messages.map((m) => m.toJson()).toList();
      await _box.put(_messagesKey, jsonList);
    } catch (e) {
      throw CacheException('Failed to save messages: $e');
    }
  }

  /// Append a single message to the cached list.
  Future<void> appendMessage(ChatMessageModel message) async {
    final messages = loadMessages();
    messages.add(message);
    await saveMessages(messages);
  }

  /// Clear all cached messages.
  Future<void> clearMessages() async {
    try {
      await _box.delete(_messagesKey);
    } catch (e) {
      throw CacheException('Failed to clear messages: $e');
    }
  }

  /// Returns true if there is any cached data.
  bool hasCachedMessages() {
    return _box.containsKey(_messagesKey);
  }
}
