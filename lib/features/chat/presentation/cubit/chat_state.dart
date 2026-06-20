import 'package:aoun/features/chat/domain/entities/chat_entity.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  const ChatLoaded(this.messages);
}

class ChatStreaming extends ChatState {
  final List<ChatMessage> messages;
  const ChatStreaming(this.messages);
}

class ChatStreamingUpdate extends ChatState {
  final List<ChatMessage> messages;
  const ChatStreamingUpdate(this.messages);
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}
