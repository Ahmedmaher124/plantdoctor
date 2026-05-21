import '../entities/chat_message.dart';

/// Contract for the chat repository.
abstract class ChatRepository {
  /// Sends [messages] (full conversation history) to Gemini and returns
  /// the model's reply text, or throws an Exception on failure.
  Future<String> sendMessage(List<ChatMessage> messages);
}
