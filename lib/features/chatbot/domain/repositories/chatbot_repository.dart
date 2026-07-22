import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';

/// Abstract definition of the chatbot repository contract.
/// Implemented in the data layer.
abstract class ChatbotRepository {
  /// Fetches the full chat history from the remote API.
  Future<List<ChatMessage>> getHistory();

  /// Sends a user message and returns the AI response message.
  Future<ChatMessage> sendMessage(String message);

  /// Clears the full conversation history.
  Future<void> clearHistory();
}
