import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

/// Use-case: send the current conversation to Gemini and get a reply.
class SendMessageUseCase {
  final ChatRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<String> call(List<ChatMessage> messages) =>
      _repository.sendMessage(messages);
}
