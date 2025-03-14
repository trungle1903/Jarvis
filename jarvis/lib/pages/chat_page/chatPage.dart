import 'package:flutter/material.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: SideBar(),
      endDrawer: HistoryDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      SizedBox(
                        child: DropdownAI(
                          aiModels: _aiModels,
                          onChange: (nameModel) {
                            _currentModelPathLogo =
                                _aiModels.firstWhere(
                                  (element) => element['name'] == nameModel,
                                )['logo']!;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(onPressed: () {}, child: Text("+ Create Bot")),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: Icon(Icons.history, color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.message, color: jvBlue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
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
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.attach_file, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.library_books, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
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
