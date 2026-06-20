import 'package:aoun/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:aoun/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:aoun/features/chat/domain/repositories/chat_message_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;

  ChatRepositoryImpl(this.remote, this.local);

  @override
  Future<void> sendMessageStream(
    String message,
    Function(String chunk) onChunk, {
    String? filePath,
    MessageType? type,
  }) async {
    await remote.sendStream(message, onChunk, filePath: filePath, type: type);
  }

  @override
  List<ChatMessage> loadMessages() {
    final data = local.loadMessages();
    return data
        .map(
          (e) => ChatMessage(
            role: e['role']!,
            content: e['content']!,
            createdAt: DateTime.parse(
              e['createdAt'] ?? DateTime.now().toIso8601String(),
            ),

            type: MessageType.values.firstWhere(
              (t) => t.name == e['type'],
              orElse: () => MessageType.text,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    await local.saveMessage({
      "role": message.role,
      "content":
          message.content, // This will be the text OR the local file path
      "createdAt": message.createdAt.toIso8601String(),
      "type": message.type.name, // Save the enum as a string
    });
  }
}
