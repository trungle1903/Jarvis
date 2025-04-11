import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';

class CreatePromptDialog extends StatefulWidget {
  final Function(Prompt)? onCreate;
  final PromptApiService apiService;
  const CreatePromptDialog({super.key, this.onCreate, required this.apiService});

  @override
  _CreatePromptDialogState createState() => _CreatePromptDialogState();
}

class _CreatePromptDialogState extends State<CreatePromptDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'other';
  String _selectedLanguage = 'English';
  final bool _isPublic = false;
  bool _isLoading = false;
  final List<String> categories = [
    'business',
    'career',
    'chatbot',
    'coding',
    'education',
    'fun',
    'marketing',
    'productivity',
    'seo',
    'writing',
    'other'
  ];

    final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Other'
  ];

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
                "New Prompt",
                style: Theme.of(context).dialogTheme.titleTextStyle,
              ),),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: 
                    Column(
                      mainAxisSize: MainAxisSize.min,
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
                        Text("Description * ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller:  _descriptionController,
                          decoration: InputDecoration(
                            hintText: "Describe what your prompt does",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
                        ),
                        SizedBox(height: 16),
                        Text("Prompt *",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextFormField(
                          controller: _contentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "e.g.: Write an article about [TOPIC], make sure include these keywords: [KEYWORD]",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
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
                        
                        SizedBox(height: 20,),
                      ],
                ),
              ),
              )
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
                    text: 'Create',
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newPrompt = {
        'title': _titleController.text,
        'content': _contentController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'language': _selectedLanguage,
        'isPublic': _isPublic,
      };

      final createdPrompt = await widget.apiService.createPrompt(newPrompt);
      
      if (widget.onCreate != null) {
        widget.onCreate!(createdPrompt);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt created successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create prompt: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}