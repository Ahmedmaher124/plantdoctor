/// API key for Gemini.
/// 
/// ⚠️  Replace this value with your real key before running.
/// Get yours at: https://aistudio.google.com/app/apikey
/// 
/// For production, load from environment variables or a secure vault —
/// never commit a real key to source control.
class ApiKeys {
  ApiKeys._();

  /// Gemini API key — get yours at https://aistudio.google.com/app/apikey
  static const String gemini = 'YOUR_GEMINI_API_KEY_HERE';

  /// Perenual plant disease API key — used for pest-disease-list endpoint
  static const String perenual = 'sk-CDxE6a0ff8c67673817496';
}
