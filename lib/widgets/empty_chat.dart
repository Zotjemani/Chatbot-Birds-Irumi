import 'package:material_ui/material_ui.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble,
            size: 64,
            color: Colors.blueAccent,
          ),
          SizedBox(height: 16),
          Text(
            'Halo! Ada yang bisa saya bantu?',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Mulai percakapan dengan AI.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}