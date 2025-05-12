import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/knowledge_base/knowledge_soure.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:provider/provider.dart';

class CreateAssistantDialog extends StatefulWidget {
  @override
  _CreateAssistantDialogState createState() => _CreateAssistantDialogState();
}

class _CreateAssistantDialogState extends State<CreateAssistantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool isCreateEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCreateButtonState);
  }

  void _updateCreateButtonState() {
    setState(() {
      isCreateEnabled = _nameController.text.isNotEmpty;
    });
  }

  Future<void> _createAssistant() async {
    if (!isCreateEnabled) return;

    setState(() {
      isLoading = true;
    });

    final assistantProvider = Provider.of<AssistantProvider>(
      context,
      listen: false,
    );

    final success = await assistantProvider.createAssistant(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      instructions: _instructionsController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create assistant')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Your Own Assistant",
                      style: Theme.of(context).dialogTheme.titleTextStyle,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Name *",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Enter a name for your assistant...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Description (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter description for the bot...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Instructions (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _instructionsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter instructions for the bot...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Knowledge Base (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => KnowledgeSourceDialog(knowledgeBaseId: '',),
                          );
                        },
                        icon: Icon(Icons.add, color: jvDeepBlue),
                        label: Text(
                          "Add knowledge source",
                          style: TextStyle(color: jvDeepBlue),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: jvDeepBlue),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8),
                isLoading
                    ? CircularProgressIndicator()
                    : GradientElevatedButton(
                      onPressed: isCreateEnabled ? _createAssistant : () {},
                      text: 'Create',
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
