import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageTile extends StatelessWidget {
  final bool isAI;
  final String message;
  final String? aiName;
  final String? aiLogo;

  const MessageTile({
    super.key,
    required this.isAI,
    required this.message,
    this.aiName,
    this.aiLogo,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Copied to clipboard!")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                  isAI
                      ? (aiLogo ?? 'assets/assets/logos/default_ai.png')
                      : 'assets/logos/user_avatar.png',
                ),
                radius: 18,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                isAI ? (aiName ?? "AI Model") : "You",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.only(left: 50),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: MarkdownBody(
                        data: message,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                          p: const TextStyle(fontSize: 16),
                        ),
                        onTapLink: (text, href, title) {
                          
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.grey, size: 16),
                      onPressed: () => _copyToClipboard(context),
                    ),
                    if (isAI)
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.grey, size: 16),
                        onPressed: () {
                          // TODO: Implement reload function
                        },
                      ),
                    if (!isAI)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey, size: 16),
                        onPressed: () {
                          // TODO: Implement edit function
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
