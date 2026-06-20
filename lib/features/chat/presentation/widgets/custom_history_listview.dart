import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter/material.dart';

class CustomHistoryListview extends StatelessWidget {
  const CustomHistoryListview({super.key, required this.history});

  final List<ChatMessage> history;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final msg = history[index];
        final isUser = msg.role == "user";

        return ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          leading: CircleAvatar(
            backgroundColor: isUser ? Colors.blue[50] : Colors.green[50],
            child: Icon(
              isUser ? Icons.person_outline : Icons.auto_awesome_outlined,
              size: 20,
              color: isUser ? Colors.blue : Colors.green,
            ),
          ),
          title: Text(
            msg.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Text(
            "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey[100]!),
          ),
          tileColor: Colors.grey[50],
        );
      },
    );
  }
}
