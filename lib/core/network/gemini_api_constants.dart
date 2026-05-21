class GeminiApiConstants {
  GeminiApiConstants._();

  static const String baseUrl = 'https://generativelanguage.googleapis.com/';
  static const String model = 'gemini-2.5-flash';
  static const String apiVersion = 'v1beta';

  /// Build the full endpoint for generateContent.
  static String generateContentEndpoint(String apiKey) =>
      '$apiVersion/models/$model:generateContent?key=$apiKey';

  // ── Agricultural system prompt ─────────────────────────────────────────────
  // Instructs Gemini to act as an expert plant-disease consultant and respond
  // in the same language the user writes in.
  static const String systemPrompt = '''
You are PlantDoc, an expert agricultural AI assistant specializing in:
- Plant disease diagnosis and treatment recommendations
- Crop health monitoring and prevention strategies
- Organic and chemical treatment options with dosages
- Seasonal planting advice and soil management
- Pest identification and integrated pest management

Always respond in the same language the user writes in.
Structure your responses clearly with:
• Diagnosis (if applicable)
• Cause / pathogen
• Recommended treatments (organic & chemical options)
• Prevention tips

Keep answers concise, practical, and farmer-friendly.
''';
}
