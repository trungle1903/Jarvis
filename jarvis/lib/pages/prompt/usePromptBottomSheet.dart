import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';

class UsePromptBottomSheet extends StatefulWidget {
  final String title;
  final String prompt;
  final String username;
  final String description;
  final String category;
  final void Function(String promptMessage) onSend;
  
  const UsePromptBottomSheet({
    required this.title,
    required this.prompt,
    required this.username,
    required this.description,
    required this.category,
    required this.onSend,
    super.key
  });

  @override
  State<UsePromptBottomSheet> createState() => _UsePromptBottomSheetState();
}

class _UsePromptBottomSheetState extends State<UsePromptBottomSheet> {

  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String get author {
    final parts = widget.username.split('@');
    return parts.isNotEmpty ? parts[0] : widget.username;
  }
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.prompt));
  }

  void _handleSend() {
    final userInput = _inputController.text.trim();
    final promptMessage = userInput.isNotEmpty
      ? "${widget.prompt}\n\n input is: $userInput"
      : widget.prompt;
    widget.onSend(promptMessage);
    print('Sending prompt message: $promptMessage');
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
                    widget.title,
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
                  "${widget.category} • by $author",
                  style: TextStyle(color: jvSubText),
                ),
              ],
            ),
            SizedBox(height: 8,),
            if (widget.description.isNotEmpty)
            Row(
              children: [
                Flexible(
                  child: Text(
                    widget.description,
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
                  hintText: widget.prompt,
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
                controller: _inputController,
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
                onPressed: _handleSend,
                text: "Send",
              ),
            )
          ],
        ),
      ),
    );
  }
}