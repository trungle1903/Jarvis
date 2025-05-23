import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/models/knowledge.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class CreateKnowledgeBaseDialog extends StatefulWidget {
  @override
  _CreateKnowledgeBaseDialogState createState() => _CreateKnowledgeBaseDialogState();
}

class _CreateKnowledgeBaseDialogState extends State<CreateKnowledgeBaseDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isCreateEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCreateButtonState);
  }

  void _updateCreateButtonState() {
    setState(() {
      isCreateEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _createKnowledgeBase() async {
    if (!isCreateEnabled) return;

    setState(() {
      isLoading = true;
    });

    try {
      final knowledgeName = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      bool success = await Provider.of<KnowledgeBaseProvider>(context, listen: false).createKnowledgeBase(
        name: knowledgeName,
        description: description,
      );
      if (success) {
        Navigator.pop(context,true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create KB: $e'))
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                    "Create Knowledge Base",
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
                        onPressed: isCreateEnabled ? _createKnowledgeBase : () {},
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
