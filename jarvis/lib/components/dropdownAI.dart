import 'package:flutter/material.dart';
import 'package:jarvis/models/bot.dart';

class DropdownAI extends StatefulWidget {
  final List<Bot> assistants;
  final Bot currentAssistant;
  final ValueChanged<Bot> onChange;
  final double iconSize;
  final bool showText;

  const DropdownAI({
    super.key,
    required this.assistants,
    required this.currentAssistant,
    required this.onChange,
    this.iconSize = 30,
    this.showText = true,
  });

  @override
  State<DropdownAI> createState() => _DropdownAIState();
}

class _DropdownAIState extends State<DropdownAI> {
  late Bot _selectedAssistant;

  @override
  void initState() {
    super.initState();
    _selectedAssistant = widget.currentAssistant;
  }

  @override
  void didUpdateWidget(covariant DropdownAI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentAssistant.id != oldWidget.currentAssistant.id) {
      setState(() {
        _selectedAssistant = widget.currentAssistant;
      });
    }
  }

  String _getLogoForModel(String model) {
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
    return Center(
      child: PopupMenuButton<Bot>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        itemBuilder: (context) {
          return widget.assistants.map((assistant) {
            return PopupMenuItem<Bot>(
              value: assistant,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                    _getLogoForModel(assistant.id),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    assistant.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList();
        },
        onSelected: (assistant) {
          setState(() {
            _selectedAssistant = assistant;
          });

          widget.onChange(assistant);
        },
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
              _getLogoForModel(_selectedAssistant.id),
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              ),
            ),
            Icon(Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
