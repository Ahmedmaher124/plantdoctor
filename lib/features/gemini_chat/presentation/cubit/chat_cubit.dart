import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;

  ChatCubit({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        super(const ChatInitial());

  List<ChatMessage> get _currentMessages {
    final s = state;
    if (s is ChatLoaded) return List.from(s.messages);
    if (s is ChatError) return List.from(s.previousMessages);
    return [];
  }

  /// Sends a user message and awaits the Gemini reply.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // 1. Add user message immediately
    final userMsg = ChatMessage(
      text: trimmed,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    final messagesWithUser = [..._currentMessages, userMsg];

    emit(ChatLoaded(messages: messagesWithUser, isLoading: true));

    try {
      // 2. Call Gemini with the full conversation history
      final replyText = await _sendMessageUseCase(messagesWithUser);

      // 3. Append model reply
      final modelMsg = ChatMessage(
        text: replyText,
        role: MessageRole.model,
        timestamp: DateTime.now(),
      );

      emit(ChatLoaded(
        messages: [...messagesWithUser, modelMsg],
        isLoading: false,
      ));
    } catch (e) {
      emit(ChatError(
        message: e.toString().replaceFirst('Exception: ', ''),
        previousMessages: messagesWithUser,
      ));
    }
  }

  /// Dismisses an error and restores chat to the previous messages list.
  void dismissError() {
    if (state is ChatError) {
      final s = state as ChatError;
      emit(ChatLoaded(messages: s.previousMessages));
    }
  }

  /// Clears the entire conversation.
  void clearChat() => emit(const ChatInitial());
}
