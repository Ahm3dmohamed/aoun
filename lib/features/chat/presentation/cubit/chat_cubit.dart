import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:aoun/features/chat/domain/repositories/chat_message_repo.dart';
import 'package:aoun/features/chat/presentation/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit(this.repository) : super(ChatInitial());

  void loadMessages() {
    final messages = repository.loadMessages();
    emit(ChatLoaded(messages));
  }

  Future<void> sendMediaMessage(
    String path,
    MessageType type, {
    String? message,
  }) async {
    final mediaMessage = ChatMessage(
      role: "user",
      content: message!,
      filePath: path,
      createdAt: DateTime.now(),
      type: type,
    );

    await repository.saveMessage(mediaMessage);

    emit(ChatLoaded(repository.loadMessages()));

    if (type == MessageType.image) {
      await _processStream(
        message ?? "Describe this image",
        filePath: path,
        type: type,
      );
    }
  }

  Future<void> sendTextMessage(String message) async {
    final userMessage = ChatMessage(
      role: "user",
      content: message,
      type: MessageType.text,
      createdAt: DateTime.now(),
    );

    await repository.saveMessage(userMessage);
    emit(ChatLoaded(repository.loadMessages()));

    await _processStream(message);
  }

  Future<void> _processStream(
    String message, {
    String? filePath,
    MessageType type = MessageType.text,
  }) async {
    List<ChatMessage> currentMessages = repository.loadMessages();
    String fullResponse = "";
    ChatMessage aiMessage = ChatMessage(
      role: "assistant",
      content: "",
      createdAt: DateTime.now(),
      type: MessageType.text,
    );

    emit(ChatStreaming([...currentMessages, aiMessage]));

    // Updated sendMessageStream in repo needs to pass these extra params
    await repository.sendMessageStream(message, (chunk) {
      fullResponse += chunk;
      aiMessage = ChatMessage(
        role: "assistant",
        content: fullResponse,
        createdAt: aiMessage.createdAt,
        type: type,
      );
      emit(ChatStreaming([...currentMessages, aiMessage]));
      filePath = filePath;
      type = type;
    });

    await repository.saveMessage(aiMessage);
    emit(ChatLoaded(repository.loadMessages()));
  }

  void showHistory() {
    final messages = repository.loadMessages();
    emit(ChatLoaded(messages));
  }

  void StartNewChat() {
    emit(ChatInitial());
  }
}
