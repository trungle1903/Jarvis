import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/pages/prompt/usePromptBottomSheet.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';

class InfoPromptDialog extends StatefulWidget {
  final Prompt prompt;
  final PromptApiService apiService;
  final VoidCallback onFavoriteToggled;
  final Function(Prompt) onPromptSelected;

  const InfoPromptDialog({
    super.key,
    required this.prompt,
    required this.apiService,
    required this.onFavoriteToggled,
    required this.onPromptSelected
  });

  @override
  State<InfoPromptDialog> createState() => _InfoPromptDialogState();
}

class _InfoPromptDialogState extends State<InfoPromptDialog> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.prompt.isFavorite ?? false;
  }

  void _toggleFavorite() async {
    try {
      if (isFavorite) {
        await widget.apiService.unfavoritePrompt(widget.prompt.id);
      } else {
        await widget.apiService.favoritePrompt(widget.prompt.id);
      }
      setState(() => isFavorite = !isFavorite);
      widget.onFavoriteToggled();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle favorite')),
      );
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.prompt.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompt copied to clipboard')),
    );
  }

  void _usePrompt() {
    widget.onPromptSelected(widget.prompt);
    Navigator.of(context).pop(widget.prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.prompt.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_outline,
                      color: isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text("${widget.prompt.category} • by ${widget.prompt.userName}"),
                ],
              ),
              const SizedBox(height: 8),


              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.prompt.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  )
                ],
              ),


              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Prompt",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  hintText: widget.prompt.content,
                  border: OutlineInputBorder(),
                ),
                readOnly: true
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  GradientElevatedButton(
                    onPressed: _usePrompt,
                    text: "Use this prompt",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
