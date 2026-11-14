import 'package:material_ui/material_ui.dart';

import '../models/message_models.dart';
import '../repositories/message_repostori.dart';

import '../utils/chat_colors.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_message_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository _repository = ChatRepository();

  final TextEditingController _controller =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<Message> _messages = [];

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(
        Message(text: text, isUser: true),
      );

      _isLoading = true;
      _controller.clear();
    });

    _scrollToBottom();

    try {
      final answer = await _repository.sendMessage(text);

      if (!mounted) return;

      setState(() {
        _messages.add(
          Message(text: answer, isUser: false),
        );
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          Message(
            text: 'Terjadi kesalahan: $error',
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _clearChat() {
    if (_isLoading) return;

    setState(() {
      _messages.clear();
      _repository.clearHistory();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _repository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.background,

      appBar: ChatAppBar(
        onClear: _clearChat,
        isLoading: _isLoading,
      ),

      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              isLoading: _isLoading,
              scrollController: _scrollController,
            ),
          ),

          ChatInput(
            controller: _controller,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}