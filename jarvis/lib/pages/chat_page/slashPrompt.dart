import 'package:flutter/material.dart';
import 'package:jarvis/models/prompt.dart';

class SlashPromptSheet extends StatelessWidget {
  final List<Prompt> prompts;
  final String keyword;
  final Function(Prompt) onPromptSelected;

  const SlashPromptSheet({
    super.key,
    required this.prompts,
    required this.keyword,
    required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 200,
        minHeight: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: prompts.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No prompts found for "$keyword"',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                final prompt = prompts[index];
                return ListTile(
                  title: Text(
                    prompt.title,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    prompt.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  dense: true,
                  onTap: () {
                    debugPrint('SlashPromptSheet: Selected prompt: ${prompt.title}');
                    onPromptSelected(prompt);
                  },
                );
              },
            ),
    );
  }
}