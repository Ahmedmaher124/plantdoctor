import 'package:equatable/equatable.dart';

enum MessageRole { user, model }

/// Domain entity representing a single chat message.
class ChatMessage extends Equatable {
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final bool isLoading; // true while waiting for AI response

  const ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
  });

  bool get isUser => role == MessageRole.user;
  bool get isModel => role == MessageRole.model;

  ChatMessage copyWith({
    String? text,
    MessageRole? role,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [text, role, timestamp, isLoading];
}
