import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

/// Initial state — no messages yet.
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Messages updated (includes loading placeholder when AI is thinking).
class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatLoaded({required this.messages, this.isLoading = false});

  ChatLoaded copyWith({List<ChatMessage>? messages, bool? isLoading}) =>
      ChatLoaded(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [messages, isLoading];
}

/// Error sending or receiving a message.
class ChatError extends ChatState {
  final String message;
  final List<ChatMessage> previousMessages;

  const ChatError({required this.message, required this.previousMessages});

  @override
  List<Object?> get props => [message, previousMessages];
}
