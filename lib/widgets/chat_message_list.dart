import 'package:flutter/material.dart';

import '../../models/message_models.dart';
import 'empty_chat.dart';
import 'loading_bubble.dart';
import 'message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final List<Message> messages;
  final bool isLoading;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isLoading) {
      return const EmptyChat();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const LoadingBubble();
        }

        return MessageBubble(
          message: messages[index],
        );
      },
    );
  }
}