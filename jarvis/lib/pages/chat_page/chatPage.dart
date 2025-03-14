import 'package:flutter/material.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/bots/create_bot_dialog.dart';
import 'package:jarvis/pages/prompt_library.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageTile> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> _aiModels = [
    {'name': 'Gemini 1.5 Flash', 'logo': 'assets/logos/gemini.png'},
    {'name': 'Chat GPT 4o', 'logo': 'assets/logos/gpt.png'},
  ];

  String _currentModelName = "Chat GPT";
  String _currentModelPathLogo = "assets/logos/gpt.png";

  bool _isPromptLibraryOpen = false; // Toggle between drawers

  void onSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      messages.add(MessageTile(isAI: false, message: _messageController.text));
      messages.add(
        MessageTile(
          isAI: true,
          message: "Hello, this is Jarvis",
          aiLogo: _currentModelPathLogo,
          aiName: _currentModelName,
        ),
      );
      _messageController.clear();
    });
  }

  void openHistoryDrawer() {
    setState(() {
      _isPromptLibraryOpen = false;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void openPromptLibraryDrawer() {
    setState(() {
      _isPromptLibraryOpen = true;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(selectedIndex: 0),
      endDrawer:
          _isPromptLibraryOpen
              ? const PromptLibraryPage()
              : const HistoryDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          widget.chatName ?? "Main Chat",
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            onPressed: openHistoryDrawer,
            icon: const Icon(Icons.history, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DropdownAI(
                        aiModels: _aiModels,
                        onChange: (nameModel) {
                          setState(() {
                            _currentModelPathLogo =
                                _aiModels.firstWhere(
                                  (element) => element['name'] == nameModel,
                                )['logo']!;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      GradientElevatedButton(
                        borderRadius: 50,
                        onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CreateBotDialog(),
                        );
                      },
                    text: '+  Create Bot',
                  ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message, color: jvBlue),
                      ),
                    ],
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
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.library_books,
                          color: Colors.grey,
                        ),
                        onPressed: openPromptLibraryDrawer,
                      ),
                    ],
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: jvBlue),
                    onPressed: onSendMessage,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
