import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';

class UsePromptBottomSheet extends StatelessWidget {
  final String title;
  final String prompt;
  final String username;
  final String description;
  final String category;
  
  const UsePromptBottomSheet({
    required this.title,
    required this.prompt,
    required this.username,
    required this.description,
    required this.category,
  });
  String get author {
    final parts = username.split('@');
    return parts.isNotEmpty ? parts[0] : username;
  }
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: prompt));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Text(
                  "$category • by $author",
                  style: TextStyle(color: jvSubText),
                ),
              ],
            ),
            SizedBox(height: 8,),
            if (description.isNotEmpty)
            Row(
              children: [
                Flexible(
                  child: Text(
                    prompt,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                      "Prompt",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copyToClipboard,
                ),
                ],
            ),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: prompt,
                  border: OutlineInputBorder(),
                ),
                readOnly: true
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    "Your input",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write something here...",
                  border: OutlineInputBorder(),
                ),
              ),

            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: GradientElevatedButton(
                onPressed: () {},
                text: "Send",
              ),
            )
          ],
        ),
      ),
    );
  }
}