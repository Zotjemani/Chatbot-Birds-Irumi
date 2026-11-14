import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  OpenAIService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final List<Map<String, String>> _history = [];

  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  String get _model => dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini';

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty || _apiKey == 'sk-ISI_API_KEY_KAMU') {
      throw Exception('API key belum diisi. Periksa file .env.');
    }

    final userMessage = <String, String>{
      'role': 'user',
      'content': message,
    };

    _history.add(userMessage);

    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/responses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'instructions':
              'Kamu adalah asisten AI yang ramah dan membantu. '
              'Jawab menggunakan bahasa yang digunakan pengguna.',
          'input': _history,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'OpenAI API (${response.statusCode}): ${_readApiError(response.body)}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final output = data['output'] as List<dynamic>? ?? [];
      final answer = StringBuffer();

      for (final item in output) {
        if (item is! Map<String, dynamic> || item['type'] != 'message') {
          continue;
        }
        final content = item['content'] as List<dynamic>? ?? [];
        for (final part in content) {
          if (part is Map<String, dynamic> &&
              part['type'] == 'output_text' &&
              part['text'] is String) {
            answer.write(part['text']);
          }
        }
      }

      final result = answer.toString().trim();
      if (result.isEmpty) {
        throw Exception('GPT tidak mengembalikan teks jawaban.');
      }

      _history.add({
        'role': 'assistant',
        'content': result,
      });

      return result;
    } catch (_) {
      if (_history.isNotEmpty && _history.last == userMessage) {
        _history.removeLast();
      }
      rethrow;
    }
  }

  String _readApiError(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final error = decoded['error'];
      if (error is Map<String, dynamic>) {
        return (error['message'] ?? body).toString();
      }
    } catch (_) {
      
    }
    return body;
  }

  void clearHistory() => _history.clear();

  void dispose() => _client.close();
}
