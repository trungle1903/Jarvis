import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/bots/knowledge_soure.dart';

class CreateBotDialog extends StatefulWidget {
  @override
  _CreateBotDialogState createState() => _CreateBotDialogState();
}

class _CreateBotDialogState extends State<CreateBotDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool isCreateEnabled = false;

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

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: 500,
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Your Own Bot",
                  style: Theme.of(context).dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 16),
                Text("Name *", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter a name for your bot...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text("Instructions (Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                TextField(
                  controller: _instructionsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter instructions for the bot...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text("Knowledge Base (Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => KnowledgeSourceDialog(),
                      );
                    },
                    icon: Icon(Icons.add, color: jvDeepBlue),
                    label: Text("Add knowledge source", style: TextStyle(color:jvDeepBlue)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: jvDeepBlue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 8),
                  GradientElevatedButton(
                    onPressed: () {},
                    text: 'Create',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}