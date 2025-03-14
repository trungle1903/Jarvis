import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';

class CreatePromptDialog extends StatefulWidget {
  @override
  _CreatePromptDialogState createState() => _CreatePromptDialogState();
}

class _CreatePromptDialogState extends State<CreatePromptDialog> {
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
                  "New Prompt",
                  style: Theme.of(context).dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 16),
                Text("Name *", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name of the prompt",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text("Prompt*",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextField(
                  controller: _instructionsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "e.g.: Write an article about [TOPIC], make sure include these keywords: [KEYWORD]",
                    border: OutlineInputBorder(),
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