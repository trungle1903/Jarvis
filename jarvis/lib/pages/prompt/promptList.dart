import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/pages/prompt/usePromptBottomSheet.dart';

class PromptListWidget extends StatelessWidget {
  final List<Prompt> prompts;
  final Function(Prompt) onPromptSelected;
  final Function (String) onFavoriteToggled;

  const PromptListWidget({
    required this.prompts,
    required this.onPromptSelected,
    required this.onFavoriteToggled
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        final prompt = prompts[index];
        return Card(
          child: ListTile(
          title: Text(
            prompt.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(prompt.description),
          trailing:
           Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  prompt.isFavorite == true ? Icons.star : Icons.star_outline,
                  color: prompt.isFavorite == true ? Colors.amber : Colors.grey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.grey,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: jvBlue),
                onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return UsePromptBottomSheet(
                      title: prompt.title, 
                      prompt: prompt.content,
                      author: prompt.userName, 
                      description: prompt.description, 
                      category: prompt.category,
                    );
                  },
                );
                },
              ),
            ],
           )
        ),
        );
      },
    );
  }
}