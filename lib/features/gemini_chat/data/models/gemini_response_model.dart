/// Parses the Gemini API generateContent response JSON.
class GeminiResponseModel {
  /// Extracts the reply text from a successful Gemini response.
  /// Throws [FormatException] if the expected fields are missing.
  static String parseReplyText(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List<dynamic>;
      if (candidates.isEmpty) throw const FormatException('No candidates in response');

      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      if (parts.isEmpty) throw const FormatException('No parts in content');

      return (parts[0]['text'] as String).trim();
    } catch (e) {
      throw FormatException('Failed to parse Gemini response: $e\nRaw: $json');
    }
  }

  /// Returns true if the response was blocked by safety filters.
  static bool isBlocked(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List<dynamic>;
      if (candidates.isEmpty) return false;
      final finishReason = candidates[0]['finishReason'] as String?;
      return finishReason == 'SAFETY';
    } catch (_) {
      return false;
    }
  }
}
