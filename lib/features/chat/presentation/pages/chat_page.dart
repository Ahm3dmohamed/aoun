import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:aoun/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:aoun/features/chat/presentation/cubit/chat_state.dart';
import 'package:aoun/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:aoun/features/chat/presentation/widgets/message_bubble.dart';
import 'package:aoun/features/chat/presentation/widgets/typing_indicator_widget.dart';
import 'package:aoun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/show_history_sheet_widget.dart' show showHistorySheet;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().StartNewChat();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          t.chatTitle,
          style: const TextStyle(color: Colors.black, fontSize: 19),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton.icon(
            onPressed: () => showHistorySheet(context),
            icon: const Icon(Icons.history, color: Colors.blue, size: 22),
            label: Text(""),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                List<ChatMessage> messages = [];
                bool isTyping = false;

                if (state is ChatLoaded) messages = state.messages;
                if (state is ChatStreaming) {
                  messages = state.messages;
                  isTyping =
                      messages.isNotEmpty &&
                      messages.last.role == "assistant" &&
                      messages.last.content.isEmpty;
                }

                _scrollToBottom();

                if (messages.isEmpty && !isTyping) {
                  return Center(
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                  );
                }
                if (state is ChatError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MessageBubble(message: msg, isUser: msg.role == "user"),
                        if (msg.role == "assistant" && msg.content.isEmpty)
                          const TypingIndicator(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(controller: _controller),
        ],
      ),
    );
  }
}
