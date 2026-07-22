import 'package:equatable/equatable.dart';

/// Domain entity representing a single chat message.
/// Sender is either 'user' or 'ai'.
class ChatMessage extends Equatable {
  final String id;
  final String message;
  final String sender; // 'user' | 'ai'
  final DateTime timestamp;
  final bool isError;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.sender,
    required this.timestamp,
    this.isError = false,
    this.isLoading = false,
  });

  bool get isUser => sender == 'user';
  bool get isAi => sender == 'ai';

  ChatMessage copyWith({
    String? id,
    String? message,
    String? sender,
    DateTime? timestamp,
    bool? isError,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [id, message, sender, timestamp, isError, isLoading];
}
