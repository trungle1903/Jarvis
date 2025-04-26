import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class EmptyPromptWidget extends StatelessWidget {
  final VoidCallback onCreatePrompt;

  const EmptyPromptWidget({required this.onCreatePrompt});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/imgs/no-results.png", height: 150),
        const SizedBox(height: 10),
        const Text(
          "No prompts found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: onCreatePrompt,
          child: const Text(
            "Create your own prompt",
            style: TextStyle(color: jvBlue),
          ),
        ),
      ],
    );
  }
}