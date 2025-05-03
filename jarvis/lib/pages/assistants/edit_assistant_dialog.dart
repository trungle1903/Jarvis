import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:provider/provider.dart';

class EditAssistantDialog extends StatefulWidget {
  final Assistant assistant;

  const EditAssistantDialog({super.key, required this.assistant});

  @override
  _EditAssistantDialogState createState() => _EditAssistantDialogState();
}

class _EditAssistantDialogState extends State<EditAssistantDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructionsController;
  bool isUpdateEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.assistant.assistantName,
    );
    _descriptionController = TextEditingController(
      text: widget.assistant.description ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.assistant.instructions ?? '',
    );
    _nameController.addListener(_updateUpdateButtonState);
    _updateUpdateButtonState();
  }

  void _updateUpdateButtonState() {
    setState(() {
      isUpdateEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _updateAssistant() async {
    if (!isUpdateEnabled) return;

    setState(() {
      isLoading = true;
    });

    final assistantProvider = Provider.of<AssistantProvider>(
      context,
      listen: false,
    );

    final success = await assistantProvider.updateAssistant(
      id: widget.assistant.id,
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
      ).showSnackBar(SnackBar(content: Text('Failed to update assistant')));
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Assistant",
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
                        hintText: "Edit assistant name...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Edit assistant description...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Instructions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _instructionsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Edit assistant instructions...",
                        border: OutlineInputBorder(),
                      ),
                    ),
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
                      onPressed: _updateAssistant,
                      text: "Update",
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
