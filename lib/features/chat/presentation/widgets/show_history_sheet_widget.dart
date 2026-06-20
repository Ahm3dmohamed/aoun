import 'package:aoun/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:aoun/features/chat/presentation/cubit/chat_state.dart';
import 'package:aoun/features/chat/presentation/widgets/custom_history_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showHistorySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle for aesthetics
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    "Chat History",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final messages = context
                      .read<ChatCubit>()
                      .repository
                      .loadMessages();

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("No history yet. Start chatting!"),
                    );
                  }

                  final history = messages.reversed.toList();

                  return CustomHistoryListview(history: history);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
