import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/email_page/emailOptions.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<MessageTile> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _aiModels = [
    {'name': 'Gemini 1.5 Flash', 'logo': 'assets/logos/gemini.png'},
    {'name': 'Chat GPT 4o', 'logo': 'assets/logos/gpt.png'},
  ];
  String _currentModelPathLogo = "assets/logos/gpt.png";
  String _currentModelName = "Chat GPT 4o";

  void onSendMessage(String sendMessage) {
    setState(() {
      messages.add(MessageTile(isAI: false, message: sendMessage));
      messages.add(
        MessageTile(
          isAI: true,
          message: "OK",
          aiLogo: _currentModelPathLogo,
          aiName: _currentModelName,
        ),
      );
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
                messages.isEmpty
                    ? const Center(child: Text("Start generating emails..."))
                    : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return messages[index];
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(child: EmailOptions()),
                const SizedBox(width: 10),
                DropdownAI(
                  aiModels: _aiModels,
                  onChange: (nameModel) {
                    setState(() {
                      _currentModelName = _currentModelName;
                      _currentModelPathLogo =
                          _aiModels.firstWhere(
                            (element) => element['name'] == nameModel,
                          )['logo']!;
                    });
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Ask me anything, press '/' for prompts...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: jvBlue),
                  onPressed: () {
                    onSendMessage(_messageController.text);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
