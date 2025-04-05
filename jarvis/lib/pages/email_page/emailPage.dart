import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/assistant.dart';
import 'package:jarvis/pages/email_page/emailOptions.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final List<MessageTile> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final List<Assistant> _aiModels = [
    Assistant(id: 'gemini', name: 'Gemini 1.5 Flash', model: 'gemini'),
    Assistant(id: 'gpt-4', name: 'Chat GPT 4o', model: 'gpt-4'),
  ];
  late Assistant _currentAssistant;

  @override
  void initState() {
    super.initState();
    _currentAssistant = _aiModels[1]; // Default to GPT
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(MessageTile(isAI: false, message: message));
      _messages.add(
        MessageTile(
          isAI: true,
          message:
              "Here's your generated email...", // Replace with actual API response
          aiLogo: _getAssistantLogo(_currentAssistant.model),
          aiName: _currentAssistant.name,
        ),
      );
      _messageController.clear();
    });
  }

  String _getAssistantLogo(String model) {
    switch (model) {
      case 'gemini':
        return 'assets/logos/gemini.png';
      case 'gpt-4':
        return 'assets/logos/gpt.png';
      default:
        return 'assets/logos/default_ai.png';
    }
  }

  void _handleModelChange(Assistant newAssistant) {
    setState(() {
      _currentAssistant = newAssistant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(selectedIndex: 3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Email Generator",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? const Center(
                      child: Text(
                        "Start generating emails...",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => _messages[index],
                    ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: EmailOptions(
                  onOptionSelected: (option) {
                    _sendMessage("Generate email about $option");
                  },
                ),
              ),
              const SizedBox(width: 10),
              DropdownAI(
                assistants: _aiModels,
                currentAssistant: _currentAssistant,
                onChange: _handleModelChange,
                showText: false,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: "Describe the email you want to generate...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: jvBlue),
                onPressed: () => _sendMessage(_messageController.text),
              ),
            ),
            onSubmitted: _sendMessage,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
