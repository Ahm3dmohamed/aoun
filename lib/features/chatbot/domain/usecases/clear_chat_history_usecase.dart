import 'package:aoun/features/chatbot/domain/repositories/chatbot_repository.dart';

/// Use case: clear the full conversation history (both local cache and remote server).
class ClearChatHistoryUseCase {
  final ChatbotRepository repository;

  const ClearChatHistoryUseCase(this.repository);

  Future<void> call() => repository.clearHistory();
}
