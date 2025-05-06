import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class EditKnowledgeBaseDialog extends StatefulWidget {
  final Knowledge knowledge;
  const EditKnowledgeBaseDialog({super.key, required this.knowledge});
  @override
  _EditKnowledgeBaseDialogState createState() => _EditKnowledgeBaseDialogState();
}

class _EditKnowledgeBaseDialogState extends State<EditKnowledgeBaseDialog> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  bool isUpdateEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.knowledge.knowledgeName);
    _descriptionController = TextEditingController(text:widget.knowledge.description);
    _nameController.addListener(_updateUpdateButtonState);
    _updateUpdateButtonState();
  }

  void _updateUpdateButtonState() {
    setState(() {
      isUpdateEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _editKnowledgeBase() async {
    if (!isUpdateEnabled) return;

    setState(() {
      isLoading = true;
    });

    final knowledgeName = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    final success = await Provider.of<KnowledgeBaseProvider>(context, listen: false).updateKnowledgeBase(
      id: widget.knowledge.id,
      name: knowledgeName,
      description: description,
    );

    setState(() {
      isLoading = false;
    });


    if (success) {
      Navigator.pop(context,true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update KB')));
    }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Knowledge Base",
                    style: Theme.of(context).dialogTheme.titleTextStyle,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Knowledge Base Name *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter knowledge base name...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description (Optional)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Enter description...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                isLoading
                    ? const CircularProgressIndicator()
                    : GradientElevatedButton(
                        onPressed: isUpdateEnabled ? _editKnowledgeBase : () {},
                        text: 'Update',
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
