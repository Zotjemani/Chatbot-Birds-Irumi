import 'package:material_ui/material_ui.dart';
import '../utils/chat_colors.dart';

class ChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onClear;

  final bool isLoading;

  const ChatAppBar({
    super.key,
    required this.onClear,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ChatColors.appBar,
      title: const Row(
        children: [
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Birds',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                'AI Chat',
                style: TextStyle(
                  fontSize: 11,
                  color: ChatColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: isLoading ? null : onClear,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus percakapan',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}