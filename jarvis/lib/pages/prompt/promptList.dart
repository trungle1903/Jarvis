import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/pages/prompt/editPromptDialog.dart';
import 'package:jarvis/pages/prompt/usePromptBottomSheet.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';

class PromptListWidget extends StatelessWidget {
  final List<Prompt> prompts;
  final Function(Prompt) onPromptSelected;
  final Function (String) onFavoriteToggled;
  final bool isMyPromptTab;
  final PromptApiService apiService;
  final VoidCallback onReload;

  const PromptListWidget({super.key, 
    required this.prompts,
    required this.onPromptSelected,
    required this.onFavoriteToggled,
    required this.isMyPromptTab, 
    required this.apiService, 
    required this.onReload
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
              if (isMyPromptTab) ...[
                IconButton(
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (_) => EditPromptDialog(
                        prompt: prompt, 
                        apiService: apiService, 
                        onUpdated: onReload)
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.grey,),
                ),
                IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Prompt'),
                        content: Text('Are you sure you want to delete this prompt?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                        ],
                      )
                    );
                    if (confirm == true) {
                      await apiService.deletePrompt(prompt.id);
                      onReload();
                    }
                  }, 
                  icon: Icon(Icons.delete, color: Colors.grey,)
                )
              ] else ...[
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
              ],
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
                      username: prompt.userName, 
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