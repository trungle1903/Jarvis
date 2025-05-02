import 'package:flutter/material.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/pages/assistants/create_assistant_dialog.dart';
import 'package:jarvis/pages/prompt/prompt_library.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String? chatName;
  final Bot? assistant;
  const ChatPage({super.key, this.chatName = "Chat", this.assistant});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPromptLibraryOpen = false;
  List<Bot> _availableAssistants = [];
  Bot? _currentAssistant;
  @override
  void initState() {
    super.initState();
    _loadAssistants();
  }

  Future<void> _loadAssistants() async {
    setState(() {
      _availableAssistants = [
        Bot(
          id: 'gemini-1.5-flash-latest',
          name: 'Gemini 1.5 Flash',
          model: 'dify',
        ),
        Bot(id: 'gpt-4o-mini', name: 'Chat GPT 4o', model: 'dify'),
        if (widget.assistant != null) widget.assistant!,
      ];
      _currentAssistant = widget.assistant ?? _availableAssistants.first;
    });
  }

  void onSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(
      message: _messageController.text,
      assistantId: _currentAssistant!.id,
      assistantName: _currentAssistant!.name,
    );
    _messageController.clear();
  }

  void openHistoryDrawer() {
    setState(() => _isPromptLibraryOpen = false);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void openPromptLibraryDrawer() {
    setState(() => _isPromptLibraryOpen = true);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _handleModelChange(Bot newAssistant) {
    setState(() {
      _currentAssistant = newAssistant;
    });
  }

  String _getAssistantLogo(String? model) {
    switch (model) {
      case 'gemini-1.5-flash-latest':
        return 'assets/logos/gemini.png';
      case 'gpt-4o-mini':
        return 'assets/logos/gpt.png';
      default:
        return 'assets/logos/default_ai.png';
    }
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
          widget.chatName ?? _currentAssistant?.name ?? "Chat",
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
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return MessageTile(
                        isAI: message.role == 'model',
                        message: message.content,
                        aiLogo: _getAssistantLogo(message.assistant.id),
                        aiName: message.assistant.name,
                      );
                    },
                  ),
                ),
                if (chatProvider.isLoading)
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (chatProvider.error != null)
                  Text(
                    chatProvider.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                _buildInputSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DropdownAI(
                    assistants: _availableAssistants,
                    currentAssistant: _currentAssistant!,
                    onChange: _handleModelChange,
                  ),
                  const SizedBox(width: 10),
                  GradientElevatedButton(
                    borderRadius: 50,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateAssistantDialog(),
                      );
                    },
                    text: '+  Create Bot',
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Provider.of<ChatProvider>(
                    context,
                    listen: false,
                  ).clearConversation();
                },
                icon: const Icon(Icons.message, color: jvBlue),
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
                    icon: const Icon(Icons.library_books, color: Colors.grey),
                    onPressed: openPromptLibraryDrawer,
                  ),
                ],
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: jvBlue),
                onPressed: onSendMessage,
              ),
            ),
            onSubmitted: (_) => onSendMessage(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
