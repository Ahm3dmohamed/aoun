import 'package:aoun/features/chatbot/domain/entities/chat_message.dart';
import 'package:aoun/features/chatbot/presentation/cubit/chatbot_cubit.dart';
import 'package:aoun/features/chatbot/presentation/cubit/chatbot_state.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/features/chatbot/presentation/widgets/chat_bubble.dart';
import 'package:aoun/features/chatbot/presentation/widgets/chat_header.dart';
import 'package:aoun/features/chatbot/presentation/widgets/chat_input_field.dart';
import 'package:aoun/features/chatbot/presentation/widgets/empty_chat_view.dart';
import 'package:aoun/features/chatbot/presentation/widgets/error_chat_view.dart';
import 'package:aoun/features/chatbot/presentation/widgets/loading_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The main chatbot screen.
/// Handles all chatbot states: loading, loaded, sending, error.
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late final TextEditingController _inputController;
  late final TextEditingController _searchController;
  late final FocusNode _inputFocusNode;
  late final ScrollController _scrollController;

  bool _isSearchVisible = false;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _searchController = TextEditingController();
    _inputFocusNode = FocusNode();
    _scrollController = ScrollController();

    // Load history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatbotCubit>().loadHistory();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _searchController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Scroll to bottom
  // ---------------------------------------------------------------------------
  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Message send
  // ---------------------------------------------------------------------------
  void _sendMessage(String text) {
    context.read<ChatbotCubit>().sendMessage(text);
    _scrollToBottom();
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------
  void _toggleSearch() {
    setState(() => _isSearchVisible = true);
    _inputFocusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ChatbotCubit>().clearSearch();
    setState(() => _isSearchVisible = false);
  }

  // ---------------------------------------------------------------------------
  // Clear History
  // ---------------------------------------------------------------------------
  void _showClearHistoryDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.l10n.clearHistory,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return const SizedBox();
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: AlertDialog(
              backgroundColor: const Color(0xFF1A2332),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.redAccent,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.l10n.clearHistory,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                context.l10n.clearHistoryConfirm,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    context.l10n.cancel,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _clearHistory();
                  },
                  child: Text(
                    context.l10n.clear,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearHistory() {
    setState(() => _isClearing = true);
    context.read<ChatbotCubit>().clearSearch();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      extendBodyBehindAppBar: false,
      appBar: ChatHeader(
        isSearchVisible: _isSearchVisible,
        searchController: _searchController,
        onSearchChanged: (q) => context.read<ChatbotCubit>().searchMessages(q),
        onSearchToggle: _toggleSearch,
        onClearSearch: _clearSearch,
        onClearHistory: _showClearHistoryDialog,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1628), Color(0xFF0D1F35)],
          ),
        ),
        child: BlocConsumer<ChatbotCubit, ChatbotState>(
          listenWhen: (prev, curr) => curr != prev,
          listener: (context, state) {
            // Auto-scroll when new messages arrive
            if (state is ChatbotHistoryLoaded ||
                state is ChatbotSendingMessage) {
              _scrollToBottom();
            }

            if (_isClearing) {
              if (state is ChatbotHistoryLoaded) {
                setState(() => _isClearing = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.clearHistorySuccess),
                    backgroundColor: const Color(0xFF188894),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              } else if (state is ChatbotError) {
                setState(() => _isClearing = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${context.l10n.clearHistoryFailure}: ${state.errorMessage}',
                    ),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }
            } else if (state is ChatbotError &&
                state.failedUserMessage == null &&
                state.messages.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            }
          },
          buildWhen: (prev, curr) => curr != prev,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(child: _buildBody(state)),
                _buildInput(state),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body content per state
  // ---------------------------------------------------------------------------
  Widget _buildBody(ChatbotState state) {
    if (state is ChatbotLoadingHistory) {
      return const LoadingChatView();
    }

    if (state is ChatbotInitial) {
      return const LoadingChatView();
    }

    if (state is ChatbotError && state.messages.isEmpty) {
      return ErrorChatView(
        message: state.errorMessage,
        onRetry: () => context.read<ChatbotCubit>().loadHistory(),
      );
    }

    final messages = _getMessages(state);
    final searchQuery = state is ChatbotHistoryLoaded ? state.searchQuery : '';
    final isSearching = searchQuery.isNotEmpty;
    final displayMessages = isSearching
        ? (state as ChatbotHistoryLoaded).filteredMessages
        : messages;

    if (displayMessages.isEmpty && !isSearching) {
      return EmptyChatView(onSuggestionTap: _sendMessage);
    }

    if (displayMessages.isEmpty && isSearching) {
      return _NoSearchResults(query: searchQuery);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ChatbotCubit>().refreshHistory(),
      color: const Color(0xFF188894),
      backgroundColor: const Color(0xFF1A2332),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
        itemCount: displayMessages.length,
        itemBuilder: (context, index) {
          final message = displayMessages[index];
          return ChatBubble(
            key: ValueKey(message.id),
            message: message,
            searchQuery: isSearching ? searchQuery : null,
            isHighlighted:
                state is ChatbotHistoryLoaded &&
                state.highlightedMessageId == message.id,
            onRegenerate: message.isAi
                ? () => context.read<ChatbotCubit>().regenerateLastResponse()
                : null,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Input field (disabled while sending)
  // ---------------------------------------------------------------------------
  Widget _buildInput(ChatbotState state) {
    final isSending = state is ChatbotSendingMessage;
    return ChatInputField(
      controller: _inputController,
      focusNode: _inputFocusNode,
      isLoading: isSending,
      onSend: _sendMessage,
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: extract message list from any state
  // ---------------------------------------------------------------------------
  List<ChatMessage> _getMessages(ChatbotState state) {
    if (state is ChatbotHistoryLoaded) return state.messages;
    if (state is ChatbotSendingMessage) return state.messages;
    if (state is ChatbotError) return state.messages;
    return const [];
  }
}

// ---------------------------------------------------------------------------
// No search results placeholder
// ---------------------------------------------------------------------------
class _NoSearchResults extends StatelessWidget {
  final String query;
  const _NoSearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, color: Colors.white24, size: 52.sp),
          SizedBox(height: 16.h),
          Text(
            'No results for "$query"',
            style: TextStyle(color: Colors.white38, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
