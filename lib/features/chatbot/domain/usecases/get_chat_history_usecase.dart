import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/domain/repositories/chatbot_repository.dart';

/// Use case: load the full conversation history.
class GetChatHistoryUseCase {
  final ChatbotRepository repository;

  const GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessage>> call() => repository.getHistory();
}
