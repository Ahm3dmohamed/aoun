import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aoun/features/chat/domain/entities/chat_entity.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const MessageBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? Colors.blueAccent : Colors.grey.shade300;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 18),
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.image:
        if (message.filePath != null && File(message.filePath!).existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(message.filePath!), fit: BoxFit.cover),
          );
        } else {
          return Text(
            message.content,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          );
        }

      case MessageType.text:
      default:
        return Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        );
    }
  }
}
