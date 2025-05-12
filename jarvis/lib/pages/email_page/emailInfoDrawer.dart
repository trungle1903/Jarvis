import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/providers/email_provider.dart';
import 'package:provider/provider.dart';

class EmailInfoDrawer extends StatefulWidget {
  @override
  _EmailInfoDrawerState createState() => _EmailInfoDrawerState();
}

class _EmailInfoDrawerState extends State<EmailInfoDrawer> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _emailContentController = TextEditingController();

  String? _selectedLanguage = 'Vietnamese';
  bool isLoading = false;

  void _clearAllFields() {
    _subjectController.clear();
    _senderController.clear();
    _receiverController.clear();
    _emailContentController.clear();
    setState(() {
      _selectedLanguage = 'Vietnamese';
    });
  }

  Future<void> _sendEmailRequest() async {
    if (_subjectController.text.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final emailProvider = Provider.of<EmailProvider>(context, listen: false);
      final success = await emailProvider.replyIdea(
        subject: _subjectController.text.trim(),
        sender: _senderController.text.trim(),
        receiver: _receiverController.text.trim(),
        language: _selectedLanguage ?? 'Vietnamese',
        emailContent: _emailContentController.text.trim(),
      );
      emailProvider.isImproved = false;
      if (success) {
        Navigator.pop(context, {
          'subject': _subjectController.text.trim(),
          'sender': _senderController.text.trim(),
          'receiver': _receiverController.text.trim(),
          'emailContent': _emailContentController.text.trim(),
          'language': _selectedLanguage ?? 'Vietnamese',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ideas generated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate ideas.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Compose Email",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: _clearAllFields,
                child: const Text("Clear All"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Subject *"),
                  _buildTextField(_subjectController, "Enter subject..."),
                  const SizedBox(height: 12),
                  _buildLabel("Sender *"),
                  _buildTextField(_senderController, "Enter sender email..."),
                  const SizedBox(height: 12),
                  _buildLabel("Receiver *"),
                  _buildTextField(_receiverController, "Enter receiver email..."),
                  const SizedBox(height: 12),
                  _buildLabel("Email Content"),
                  _buildTextField(_emailContentController, "Paste email content...", maxLines: 6),
                  const SizedBox(height: 12),
                  _buildLabel("Language"),
                  _buildDropdown(
                    value: _selectedLanguage,
                    items: ['Vietnamese', 'English'],
                    onChanged: (val) => setState(() => _selectedLanguage = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GradientElevatedButton(
                        onPressed: _sendEmailRequest,
                        text: 'Generate Idea',
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: onChanged,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }
}
