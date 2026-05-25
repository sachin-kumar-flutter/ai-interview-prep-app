import 'dart:convert';

import 'package:http/http.dart' as http;

/// Calls Google's Gemini API and returns the model's text reply.
class AiService {
  // ---------------------------------------------------------------------------
  // WHERE TO PASTE YOUR API KEY
  // ---------------------------------------------------------------------------
  // 1. Get a free key: https://aistudio.google.com/apikey
  // 2. Replace the text below (between the quotes) with your real key.
  //    Example: static const String _apiKey = 'AIzaSy...your_key...';
  // 3. Do not commit this file to a public repo with a real key inside.
  // ---------------------------------------------------------------------------
  static const String _apiKey = 'AIzaSyDjfo9Pa2oTaTZI1urswVOWDPZyg5MsEBk';

  /// Gemini model used for generateContent. You can switch to e.g.
  /// `gemini-1.5-flash` if your key does not support this model yet.
  static const String _model = 'gemini-2.0-flash';

  static final Uri _endpoint = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
  );

  /// Sends [prompt] to Gemini and returns the assistant's text answer.
  Future<String> getAIResponse(String prompt) async {
    if (prompt.trim().isEmpty) {
      throw Exception('Prompt cannot be empty.');
    }

    if (_apiKey.isEmpty || _apiKey == 'PASTE_YOUR_GEMINI_API_KEY_HERE') {
      throw Exception(
        'Set your Gemini API key in lib/services/ai_service.dart '
        '(the _apiKey constant near the top of the file).',
      );
    }

    final Map<String, dynamic> body = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
    };

    try {
      final http.Response response = await http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': _apiKey,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw Exception(_messageFromErrorResponse(response));
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final String? text = _extractText(data);
      if (text == null || text.isEmpty) {
        throw Exception('Gemini returned an empty response. Try again.');
      }

      return text;
    } on Exception {
      rethrow;
    } catch (error) {
      throw Exception('Could not reach Gemini: $error');
    }
  }

  /// Reads the first text part from a successful Gemini JSON body.
  String? _extractText(Map<String, dynamic> data) {
    final List<dynamic>? candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return null;

    final Map<String, dynamic>? content =
        candidates.first['content'] as Map<String, dynamic>?;
    if (content == null) return null;

    final List<dynamic>? parts = content['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) return null;

    return parts.first['text'] as String?;
  }

  /// Builds a short, readable error from a non-200 API response.
  String _messageFromErrorResponse(http.Response response) {
    try {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic>? error =
          data['error'] as Map<String, dynamic>?;
      final String? message = error?['message'] as String?;
      if (message != null && message.isNotEmpty) {
        return 'Gemini error (${response.statusCode}): $message';
      }
    } catch (_) {
      // Fall through to generic message.
    }
    return 'Gemini request failed (${response.statusCode}): ${response.body}';
  }
}
