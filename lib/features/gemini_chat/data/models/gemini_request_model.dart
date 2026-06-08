import '../../domain/entities/chat_message.dart';

/// Serializes a [ChatMessage] into the Gemini API `contents` format.
class GeminiRequestModel {
  /// Builds the full request body for the generateContent endpoint.
  static Map<String, dynamic> buildBody({
    required List<ChatMessage> messages,
    required String systemPrompt,
  }) {
    // Build the `contents` array from the conversation history
    final contents = messages
        .map((msg) => {
              'role': msg.role == MessageRole.user ? 'user' : 'model',
              'parts': [
                {'text': msg.text}
              ],
            })
        .toList();

    return {
      'system_instruction': {
        'parts': [
          {'text': systemPrompt}
        ]
      },
      'contents': contents,
      'generationConfig': {
        'temperature': 0.7,
        'topP': 0.95,
        'topK': 40,
        'maxOutputTokens': 2048,
      },
      'safetySettings': [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          'category': 'HARM_CATEGORY_HATE_SPEECH',
          'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
        },
      ],
    };
  }
}
