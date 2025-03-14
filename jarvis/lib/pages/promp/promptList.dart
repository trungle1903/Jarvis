import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/promp/usePromptBottomSheet.dart';

class PromptListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> prompts;
  final VoidCallback onPromptSelected;

  const PromptListWidget({
    required this.prompts,
    required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
          title: Text(
            prompts[index]["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(prompts[index]["description"]!),
          trailing:
           Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  prompts[index]["isFavorite"] == true ? Icons.star : Icons.star_outline,
                  color: prompts[index]["isFavorite"] == true ? Colors.amber : Colors.grey,
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
                      title: prompts[index]["title"]!, 
                      prompt: prompts[index]["prompt"]!,
                      author: prompts[index]["author"]!, 
                      description: prompts[index]["description"]!, 
                      category: prompts[index]['category']!,
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