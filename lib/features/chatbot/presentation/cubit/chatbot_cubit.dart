import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:aoun/features/chatbot/domain/usecases/send_message_usecase.dart';
import 'package:aoun/features/chatbot/presentation/cubit/chatbot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final GetChatHistoryUseCase _getHistoryUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final Uuid _uuid = const Uuid();

  /// Tracks the last user message for retry functionality.
  String? _lastUserMessage;

  ChatbotCubit({
    required GetChatHistoryUseCase getHistoryUseCase,
    required SendMessageUseCase sendMessageUseCase,
  }) : _getHistoryUseCase = getHistoryUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       super(const ChatbotInitial());

  // ---------------------------------------------------------------------------
  // Load History
  // ---------------------------------------------------------------------------
  /// Called on screen open and pull-to-refresh.
  Future<void> loadHistory() async {
    emit(const ChatbotLoadingHistory());
    try {
      final messages = await _getHistoryUseCase();
      // Sort by timestamp ascending (oldest first)
      final sorted = List<ChatMessage>.from(messages)
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      emit(ChatbotHistoryLoaded(messages: sorted));
    } catch (e) {
      emit(
        ChatbotError(
          errorMessage: e.toString().replaceAll('ServerException: ', ''),
          messages: const [],
        ),
      );
    }
  }

  /// Pull-to-refresh: reload from API (same as loadHistory but preserves UX context).
  Future<void> refreshHistory() => loadHistory();

  // ---------------------------------------------------------------------------
  // Send Message
  // ---------------------------------------------------------------------------

  /// Sends a user message:
  /// 1. Instantly adds user message to UI.
  /// 2. Shows AI typing indicator (loading message).
  /// 3. Awaits AI response.
  /// 4. Replaces loading indicator with actual AI response.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _lastUserMessage = trimmed;

    // Get current messages list
    final currentMessages = _getCurrentMessages();

    // 1. Add user message instantly
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      message: trimmed,
      sender: 'user',
      timestamp: DateTime.now(),
    );
    final withUser = [...currentMessages, userMessage];
    emit(ChatbotSendingMessage(messages: withUser));

    // 2. Add typing indicator (AI loading message)
    final loadingId = _uuid.v4();
    final loadingMessage = ChatMessage(
      id: loadingId,
      message: '',
      sender: 'ai',
      timestamp: DateTime.now(),
      isLoading: true,
    );
    final withLoading = [...withUser, loadingMessage];
    emit(ChatbotSendingMessage(messages: withLoading));

    try {
      // 3. Call API
      final aiResponse = await _sendMessageUseCase(trimmed);

      // 4. Replace loading indicator with real response
      final finalMessages = withLoading.where((m) => m.id != loadingId).toList()
        ..add(aiResponse);

      emit(ChatbotHistoryLoaded(messages: finalMessages));
    } catch (e) {
      // Remove loading indicator and show error
      final messagesWithoutLoading = withLoading
          .where((m) => m.id != loadingId)
          .toList();

      // Add an error message bubble
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        message: e.toString().replaceAll('ServerException: ', ''),
        sender: 'ai',
        timestamp: DateTime.now(),
        isError: true,
      );

      emit(
        ChatbotError(
          errorMessage: e.toString().replaceAll('ServerException: ', ''),
          messages: [...messagesWithoutLoading, errorMessage],
          failedUserMessage: trimmed,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Retry
  // ---------------------------------------------------------------------------

  /// Retries the last failed message.
  Future<void> retryLastMessage() async {
    if (_lastUserMessage == null) return;

    // Remove the last error bubble if present
    final currentMessages = List<ChatMessage>.from(_getCurrentMessages());
    if (currentMessages.isNotEmpty && currentMessages.last.isError) {
      currentMessages.removeLast();
      // Also remove the failed user message to resend cleanly
      if (currentMessages.isNotEmpty && currentMessages.last.isUser) {
        currentMessages.removeLast();
      }
    }

    emit(ChatbotHistoryLoaded(messages: currentMessages));
    await sendMessage(_lastUserMessage!);
  }

  /// Regenerates the AI response for the last user message.
  Future<void> regenerateLastResponse() async {
    final messages = List<ChatMessage>.from(_getCurrentMessages());

    // Find the last user message
    final lastUserIndex = messages.lastIndexWhere((m) => m.isUser);
    if (lastUserIndex == -1) return;

    final lastUserMsg = messages[lastUserIndex].message;

    // Remove all messages after (and including) the last AI response
    final trimmed = messages.sublist(0, lastUserIndex + 1);

    // Remove the last user message itself (sendMessage will re-add it)
    trimmed.removeLast();

    emit(ChatbotHistoryLoaded(messages: trimmed));
    await sendMessage(lastUserMsg);
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  /// Updates the search query and triggers filtered view.
  void searchMessages(String query) {
    if (state is ChatbotHistoryLoaded) {
      final current = state as ChatbotHistoryLoaded;
      emit(current.copyWith(searchQuery: query));
    } else if (state is ChatbotError) {
      final current = state as ChatbotError;
      emit(
        ChatbotHistoryLoaded(messages: current.messages, searchQuery: query),
      );
    }
  }

  /// Clears the search query.
  void clearSearch() => searchMessages('');

  /// Highlights a specific message (used for search jump-to).
  void highlightMessage(String messageId) {
    if (state is ChatbotHistoryLoaded) {
      final current = state as ChatbotHistoryLoaded;
      emit(current.copyWith(highlightedMessageId: messageId));
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<ChatMessage> _getCurrentMessages() {
    if (state is ChatbotHistoryLoaded)
      return List.from((state as ChatbotHistoryLoaded).messages);
    if (state is ChatbotSendingMessage)
      return List.from((state as ChatbotSendingMessage).messages);
    if (state is ChatbotError)
      return List.from((state as ChatbotError).messages);
    return [];
  }
}
