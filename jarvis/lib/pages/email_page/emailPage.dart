import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/pages/email_page/emailOptions.dart';
import 'package:jarvis/providers/email_provider.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailProvider>(context);
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
                emailProvider.messages.isEmpty
                    ? const Center(
                      child: Text(
                        "Start generating emails...",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: emailProvider.messages.length,
                      itemBuilder: (context, index) => emailProvider.messages[index],
                    ),
          ),
          _buildInputSection(emailProvider),
        ],
      ),
    );
  }

  Widget _buildInputSection(EmailProvider emailProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: EmailOptions(
                  onOptionSelected: (option) {
                    emailProvider.sendMessage("Generate email about $option");
                  },
                ),
              ),
              const SizedBox(width: 10),
              DropdownAI(
                assistants: emailProvider.aiModels,
                currentAssistant: emailProvider.currentAssistant,
                onChange: emailProvider.handleModelChange,
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
                onPressed: () {
                  final message = _messageController.text;
                  if (message.trim().isNotEmpty) {
                    emailProvider.sendMessage(message);
                    _messageController.clear();
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                emailProvider.sendMessage(value);
                _messageController.clear();
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
