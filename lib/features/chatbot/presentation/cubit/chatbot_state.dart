import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

/// Initial state — nothing has been loaded yet.
class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

/// Loading history from remote/cache on screen open.
class ChatbotLoadingHistory extends ChatbotState {
  const ChatbotLoadingHistory();
}

/// History has been successfully loaded (includes search state).
class ChatbotHistoryLoaded extends ChatbotState {
  /// The full unfiltered list of messages.
  final List<ChatMessage> messages;

  /// The currently active search query (empty string = no search).
  final String searchQuery;

  /// The ID of the message to scroll/highlight (null = none).
  final String? highlightedMessageId;

  const ChatbotHistoryLoaded({
    required this.messages,
    this.searchQuery = '',
    this.highlightedMessageId,
  });

  /// Returns filtered messages based on [searchQuery].
  List<ChatMessage> get filteredMessages {
    if (searchQuery.isEmpty) return messages;
    final q = searchQuery.toLowerCase();
    return messages.where((m) => m.message.toLowerCase().contains(q)).toList();
  }

  ChatbotHistoryLoaded copyWith({
    List<ChatMessage>? messages,
    String? searchQuery,
    String? highlightedMessageId,
    bool clearHighlight = false,
  }) {
    return ChatbotHistoryLoaded(
      messages: messages ?? this.messages,
      searchQuery: searchQuery ?? this.searchQuery,
      highlightedMessageId: clearHighlight ? null : (highlightedMessageId ?? this.highlightedMessageId),
    );
  }

  @override
  List<Object?> get props => [messages, searchQuery, highlightedMessageId];
}

/// A message is being sent (typing indicator shown).
/// Contains the current messages list including the pending user message.
class ChatbotSendingMessage extends ChatbotState {
  final List<ChatMessage> messages;

  const ChatbotSendingMessage({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// Error state — keeps existing messages to avoid losing chat context.
class ChatbotError extends ChatbotState {
  final String errorMessage;
  final List<ChatMessage> messages;
  final String? failedUserMessage; // The message that failed, for retry

  const ChatbotError({
    required this.errorMessage,
    required this.messages,
    this.failedUserMessage,
  });

  @override
  List<Object?> get props => [errorMessage, messages, failedUserMessage];
}
