import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/domain/repositories/chatbot_repository.dart';

/// Use case: send a user message and receive the AI response.
class SendMessageUseCase {
  final ChatbotRepository repository;

  const SendMessageUseCase(this.repository);

  Future<ChatMessage> call(String message) => repository.sendMessage(message);
}
