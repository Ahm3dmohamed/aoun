import 'package:aoun/features/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessageStream(
    String message,
    Function(String chunk) onChunk,
  );

  Future<void> saveMessage(ChatMessage message);

  List<ChatMessage> loadMessages();
}
