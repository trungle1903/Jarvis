import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';

class EditPromptDialog extends StatefulWidget {
  final Prompt prompt;
  final PromptApiService apiService;
  final VoidCallback onUpdated;

  const EditPromptDialog({
    super.key,
    required this.prompt,
    required this.apiService,
    required this.onUpdated,
  });

  @override
  _EditPromptDialogState createState() => _EditPromptDialogState();
}

class _EditPromptDialogState extends State<EditPromptDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late String _selectedLanguage;
  bool _isLoading = false;

  final List<String> categories = [
    'business', 'career', 'chatbot', 'coding', 'education',
    'fun', 'marketing', 'productivity', 'seo', 'writing', 'other'
  ];

  final List<String> languages = [
    'English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.prompt.title);
    _contentController = TextEditingController(text: widget.prompt.content);
    _descriptionController = TextEditingController(text: widget.prompt.description);
    _selectedCategory = widget.prompt.category ?? 'other';
    _selectedLanguage = widget.prompt.language ?? 'English';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Edit Prompt",
                style: Theme.of(context).dialogTheme.titleTextStyle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title *", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "Name of the prompt",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
                      ),
                      SizedBox(height: 16),
                      Text("Description *", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: "Describe what your prompt does",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
                      ),
                      SizedBox(height: 16),
                      Text("Prompt *", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "e.g.: Write an article about [TOPIC]...",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Prompt is required' : null,
                      ),
                      SizedBox(height: 16),
                      Text("Category *", style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value!),
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        validator: (value) => value == null ? 'Please select a category' : null,
                      ),
                      SizedBox(height: 16),
                      Text("Language *", style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        items: languages.map((language) {
                          return DropdownMenuItem(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        validator: (value) => value == null ? 'Please select a language' : null,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 8),
                  GradientElevatedButton(
                    onPressed: _submitForm,
                    text: 'Save',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedPrompt = await widget.apiService.editPrompt(
        id: widget.prompt.id,
        title: _titleController.text,
        description: _descriptionController.text,
        content: _contentController.text,
        category: _selectedCategory,
        language: _selectedLanguage,
        isPublic: true
      );

      widget.onUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt updated successfully!')),
      );
      Navigator.of(context).pop(updatedPrompt);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update prompt: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
