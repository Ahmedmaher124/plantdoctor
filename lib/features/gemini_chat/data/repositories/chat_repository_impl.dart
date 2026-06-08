import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasource/gemini_remote_datasource.dart';

/// Concrete implementation of [ChatRepository].
class ChatRepositoryImpl implements ChatRepository {
  final GeminiRemoteDataSource _dataSource;

  const ChatRepositoryImpl(this._dataSource);

  @override
  Future<String> sendMessage(List<ChatMessage> messages) =>
      _dataSource.sendMessage(messages);
}
