import 'package:flutter/material.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/bot.dart';
import 'package:jarvis/models/prompt.dart';
import 'package:jarvis/pages/assistants/create_assistant_dialog.dart';
import 'package:jarvis/pages/prompt/prompt_library.dart';
import 'package:jarvis/pages/prompt/usePromptBottomSheet.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:jarvis/providers/prompt_provider.dart';
import 'package:provider/provider.dart';
import 'package:jarvis/pages/chat_page/slashPrompt.dart';

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
  final GlobalKey _textFieldKey = GlobalKey();
  bool _isPromptLibraryOpen = false;
  List<Bot> _availableAssistants = [];
  Bot? _currentAssistant;
  OverlayEntry? _overlayEntry;
  bool _isPromptSelectorOpen = false;
  List<Prompt> _cachedPrompts = [];
  bool _isLoadingAssistants = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleSlashCommand);
    _availableAssistants = [
      Bot(id: 'gemini-1.5-flash-latest', name: 'Gemini 1.5 Flash', model: 'dify'),
      Bot(id: 'gemini-1.5-pro-latest', name: 'Gemini 1.5 Pro', model: 'dify'),
      Bot(id: 'gpt-4o', name: 'Chat GPT 4o', model: 'dify'),
      Bot(id: 'gpt-4o-mini', name: 'Chat GPT 4o-mini', model: 'dify'),
    ];
    _currentAssistant = widget.assistant ?? _availableAssistants.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssistants();
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleSlashCommand);
    _messageController.dispose();
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadAssistants() async {
    final assistantProvider = Provider.of<AssistantProvider>(context, listen: false);

    setState(() {
      _isLoadingAssistants = true;
    });

    try {
      await assistantProvider.fetchAssistants();
      final fetchedAssistants = assistantProvider.assistants;

      setState(() {
        final fetchedBots = fetchedAssistants.map((assistant) => Bot(id: assistant.id, name: assistant.assistantName, model: 'knowledge-base')).toList();
        _availableAssistants = [
            ..._availableAssistants,
            ...fetchedBots];
          if (widget.assistant != null &&
              !_availableAssistants.any((bot) => bot.id == widget.assistant!.id)) {
            _availableAssistants.add(widget.assistant!);
          }

          _currentAssistant = _availableAssistants.firstWhere(
            (bot) => bot.id == (_currentAssistant?.id ?? widget.assistant?.id ?? _availableAssistants.first.id),
            orElse: () => _availableAssistants.first,
          );
        });
    } catch (e) {
      print('Error loading assistants: $e');
      setState(() {
        
      });
    }
  }
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isPromptSelectorOpen = false;
  }

  void _showPromptDropdown(List<Prompt> prompts, String keyword) {
    if (_textFieldKey.currentContext == null) return;

    final RenderBox renderBox = _textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                bottom: MediaQuery.of(context).size.height - position.dy + 8,
                width: size.width,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: SlashPromptSheet(
                    prompts: prompts,
                    keyword: keyword,
                    onPromptSelected: (prompt) {
                      _removeOverlay();
                      _handlePromptSelected(prompt);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _handlePromptSelected(Prompt selectedPrompt) async {
    if (mounted) {
      
      final fullMessage = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (_) => UsePromptBottomSheet(
          title: selectedPrompt.title,
          prompt: selectedPrompt.content,
          username: selectedPrompt.userName,
          description: selectedPrompt.description,
          category: selectedPrompt.category,
          onSend: (fullMessage) {
            
            Navigator.of(context).pop(fullMessage);
          },
        ),
      );


      if (fullMessage != null && fullMessage.trim().isNotEmpty && mounted) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.sendMessage(
          message: fullMessage,
          assistantId: _currentAssistant!.id,
          assistantName: _currentAssistant!.name,
          assistantModel: _currentAssistant!.model
        );
        _messageController.clear();
        
      } else {
        debugPrint('ChatPage: Slash message not sent - null, empty, or not mounted');
      }
    }
  }

  void _handleSlashCommand() async {
    final text = _messageController.text;

    final slashIndex = text.lastIndexOf('/');
    if (slashIndex == -1) {
      _removeOverlay();
      return;
    }

    final keyword = text.substring(slashIndex + 1).trim().toLowerCase();

    if (keyword.isEmpty) {
      _removeOverlay();
      return;
    }

    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    if (_cachedPrompts.isEmpty) {
      _isPromptSelectorOpen = true;

      final promptProvider = Provider.of<PromptProvider>(context, listen: false);
      try {
        
        await promptProvider.loadPrompts(isPublic: true);
        _cachedPrompts = promptProvider.publicPrompts;
        
      } catch (e) {
        debugPrint('ChatPage: Failed to load prompts: $e');
        _removeOverlay();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load prompts: $e')),
          );
        }
        return;
      }
    }
    final matchingPrompts = _cachedPrompts.where((prompt) {
    final titleMatch = prompt.title.toLowerCase().contains(keyword);
    final descMatch = prompt.description.toLowerCase().contains(keyword);
    return titleMatch || descMatch;
    }).toList();

    _showPromptDropdown(matchingPrompts, keyword);
  }
 
  void onSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(
      message: _messageController.text,
      assistantId: _currentAssistant!.id,
      assistantName: _currentAssistant!.name,
      assistantModel: _currentAssistant!.model
    );
    _messageController.clear();
  }

  void openHistoryDrawer() {
    setState(() => _isPromptLibraryOpen = false);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void openPromptLibraryPage() async {
    
    final selectedPrompt = await Navigator.push<Prompt>(
      context,
      MaterialPageRoute(
        builder: (context) => const PromptLibraryPage(),
      ),
    );
    
    if (selectedPrompt != null) {
      final fullMessage = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return UsePromptBottomSheet(
            title: selectedPrompt.title,
            prompt: selectedPrompt.content,
            username: selectedPrompt.userName,
            description: selectedPrompt.description,
            category: selectedPrompt.category,
            onSend: (fullMessage) {
              Navigator.of(context).pop(fullMessage);
            },
          );
        },
      );
      
      if (fullMessage != null && fullMessage.isNotEmpty) {
        setState(() {
          _messageController.text = fullMessage;
        });

      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.sendMessage(
        message: fullMessage,
        assistantId: _currentAssistant!.id,
        assistantName: _currentAssistant!.name,
        assistantModel: _currentAssistant!.model
      );
      _messageController.clear();
      print('ChatPage: Sending Prompt message: $fullMessage');
      }
    }
  }

  void _handleModelChange(Bot newAssistant) {
    setState(() {
      _currentAssistant = newAssistant;
    });
  }

  String _getAssistantLogo(String? model) {
    switch (model) {
      case 'gemini-1.5-flash-latest':
        return 'assets/logos/gemini-flash.png';
      case 'gemini-1.5-pro-latest':
        return 'assets/logos/gemini-pro.png';
      case 'gpt-4o':
        return 'assets/logos/gpt.jpg';
      case 'gpt-4o-mini':
        return 'assets/logos/gpt-mini.png';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<ChatProvider>(
                        context,
                        listen: false,
                      ).clearConversation();
                    },
                    icon: const Icon(Icons.message, color: jvBlue),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: jvBlue),
                      const SizedBox(width: 4),
                      Text(
                        Provider.of<ChatProvider>(
                          context,
                          listen: false,
                        ).token,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            key: _textFieldKey,
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
                    onPressed: openPromptLibraryPage,
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
