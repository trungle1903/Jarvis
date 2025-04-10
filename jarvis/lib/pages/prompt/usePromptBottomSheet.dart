import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';

class UsePromptBottomSheet extends StatelessWidget {
  final String title;
  final String prompt;
  final String username;
  final String description;
  final String category;
  
  const UsePromptBottomSheet({
    required this.title,
    required this.prompt,
    required this.username,
    required this.description,
    required this.category,
  });
  String get author {
    final parts = username.split('@');
    return parts.isNotEmpty ? parts[0] : username;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_left, color: Colors.black,),
                Text(title,style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 8,),
            Text(
              "$category • by $author",
              style: TextStyle(color: jvSubText),
            ),
            SizedBox(height: 8,),
            if (description.isNotEmpty)
            Text(description, style: TextStyle(fontSize: 14, color: jvSubText),),
            SizedBox(height: 16),
            Text(
                  "Prompt: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            Text(prompt, style: TextStyle(fontSize: 14, color: jvSubText),),

            SizedBox(height: 16),
            GradientElevatedButton(
              onPressed: () {},
              text: "Send",
            ),
          ],
        ),
      ),
    );
  }
}