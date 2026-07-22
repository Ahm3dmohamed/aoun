import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/chatbot/data/datasources/chatbot_local_datasource.dart';
import 'package:aoun/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/domain/repositories/chatbot_repository.dart';

/// Concrete implementation of [ChatbotRepository].
/// Network-first strategy with local cache fallback for history.
class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDatasource _remote;
  final ChatbotLocalDatasource _local;

  const ChatbotRepositoryImpl(this._remote, this._local);

  @override
  Future<List<ChatMessage>> getHistory() async {
    try {
      // Try remote first
      final remoteMessages = await _remote.getHistory();
      // Cache the fresh result
      await _local.saveMessages(remoteMessages);
      return remoteMessages;
    } on ServerException {
      // Fallback to local cache when network is unavailable
      if (_local.hasCachedMessages()) {
        return _local.loadMessages();
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessage> sendMessage(String message) async {
    final aiResponse = await _remote.sendMessage(message);
    // Append AI response to local cache for offline viewing
    await _local.appendMessage(aiResponse);
    return aiResponse;
  }

  @override
  Future<void> clearHistory() async {
    try {
      await _remote.clearHistory();
    } catch (e) {
      // Even if remote clear fails, clear the local cache so the user gets an immediate reset.
      await _local.clearMessages();
      rethrow;
    }
    await _local.clearMessages();
  }
}
