import '../services/APIopenai_service.dart';

class ChatRepository {
  final OpenAIService _service;

  ChatRepository({
    OpenAIService? service,
  }) : _service = service ?? OpenAIService();

  Future<String> sendMessage(String message) async {
    return await _service.sendMessage(message);
  }

  void clearHistory() {
    _service.clearHistory();
  }

  void dispose() {
    _service.dispose();
  }
}