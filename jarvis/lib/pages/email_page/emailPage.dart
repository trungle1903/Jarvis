import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/email_page/emailInfoDrawer.dart';
import 'package:jarvis/providers/email_provider.dart';
import 'package:provider/provider.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, String> _selectedStyle = {
    'length': 'medium',
    'formality': 'neutral',
    'tone': 'friendly',
  };

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailProvider>(context);

    return Scaffold(
      drawer: const SideBar(selectedIndex: 3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Email Generator', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: emailProvider.messages.isEmpty
                ? const Center(
                    child: Text(
                      "Start generating emails...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: emailProvider.messages.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        emailProvider.messages[index],
                        if (emailProvider.isIdeaMessage(index)) _buildIdeaButtons(index),
                        if (emailProvider.isEmailMessage(index)) _buildImproveButtons(index),
                      ],
                    ),
                  ),
          ),
          _buildStyleAndEmailSection(emailProvider),
          _buildInputSection(emailProvider),
        ],
      ),
    );
  }

  Future<void> _openEmailDrawer() async {
    final emailProvider = Provider.of<EmailProvider>(context, listen: false);
    final emailInfo = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => EmailInfoDrawer(),
    );

    final defaultEmailInfo = {
      'subject': 'Generated Email',
      'sender': 'user@example.com',
      'receiver': 'recipient@example.com',
      'mainIdea': '',
      'action': 'Generate email',
      'emailContent': '',
      'language': 'English',
      'style': _selectedStyle,
    };

    emailProvider.setLastEmailInfo(emailInfo ?? defaultEmailInfo);
  }

  Widget _buildStyleAndEmailSection(EmailProvider emailProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.email, color: jvBlue),
                onPressed: _openEmailDrawer,
                tooltip: 'Compose Email',
              ),
              const SizedBox(width: 8),
              ActionChip(
                label: const Text('Style'),
                onPressed: () => _showStyleDialog(),
                backgroundColor: jvBlue.withOpacity(0.1),
                labelStyle: const TextStyle(color: jvBlue),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                emailProvider.getEmailToken(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  void _showStyleDialog() {
    String? length = _selectedStyle['length'];
    String? formality = _selectedStyle['formality'];
    String? tone = _selectedStyle['tone'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Select Email Style'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChoiceSection('Length', ['short', 'medium', 'long'], length, (val) => setStateDialog(() => length = val)),
                const SizedBox(height: 12),
                _buildChoiceSection('Formality', ['informal', 'neutral', 'formal'], formality, (val) => setStateDialog(() => formality = val)),
                const SizedBox(height: 12),
                _buildChoiceSection('Tone', ['friendly', 'professional', 'urgent'], tone, (val) => setStateDialog(() => tone = val)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedStyle = {
                    'length': length ?? 'medium',
                    'formality': formality ?? 'neutral',
                    'tone': tone ?? 'friendly',
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, String? selected, ValueChanged<String> onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selected == option,
              onSelected: (_) => onSelected(option),
              selectedColor: jvBlue,
              labelStyle: TextStyle(color: selected == option ? Colors.white : null),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIdeaButtons(int index) {
    final provider = Provider.of<EmailProvider>(context, listen: false);
    final ideas = provider.suggestedReplies;
    final emailInfo = provider.lastEmailInfo!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: ideas.map((idea) {
          return TextButton(
            onPressed: () => provider.emailResponse(
              subject: emailInfo['subject'],
              sender: emailInfo['sender'],
              receiver: emailInfo['receiver'],
              mainIdea: idea,
              action: 'Reply to this email',
              emailContent: emailInfo['emailContent'],
              language: emailInfo['language'],
              style: _selectedStyle,
            ),
            style: TextButton.styleFrom(foregroundColor: jvDeepBlue),
            child: Text(idea, style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImproveButtons(int index) {
    final provider = Provider.of<EmailProvider>(context, listen: false);
    final actions = provider.getImproveActions(index) ?? ['Make it shorter', 'More formal', 'Friendlier tone'];
    final emailInfo = provider.lastEmailInfo!;
    final lastMessage = provider.messages[index].message;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 16,
        children: actions.map((action) {
          return TextButton(
            onPressed: () => {provider.emailResponse(
              subject: emailInfo['subject'],
              sender: emailInfo['sender'],
              receiver: emailInfo['receiver'],
              mainIdea: emailInfo['mainIdea'],
              action: action,
              emailContent: lastMessage,
              language: emailInfo['language'],
              style: _selectedStyle,
            ),
            provider.isImproved = true},
            style: TextButton.styleFrom(foregroundColor: jvDeepBlue),
            child: Text(action, style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputSection(EmailProvider emailProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: '...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: jvBlue),
                onPressed: () => _sendEmail(emailProvider),
              ),
            ),
            onSubmitted: (_) => _sendEmail(emailProvider),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _sendEmail(EmailProvider emailProvider) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (emailProvider.lastEmailInfo == null) {
      await _openEmailDrawer();
    }

    final emailInfo = emailProvider.lastEmailInfo!;
    emailProvider.emailResponse(
      subject: emailInfo['subject'],
      sender: emailInfo['sender'],
      receiver: emailInfo['receiver'],
      mainIdea: message,
      action: emailInfo['action'],
      emailContent: message,
      language: emailInfo['language'],
      style: _selectedStyle,
    );
    emailProvider.replyIdea(
      subject: emailInfo['subject'],
      sender: emailInfo['sender'],
      receiver: emailInfo['receiver'],
      language: emailInfo['language'],
      emailContent: message,
    );
    _messageController.clear();
  }
}
