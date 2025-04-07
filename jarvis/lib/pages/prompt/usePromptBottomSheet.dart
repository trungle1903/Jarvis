import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';

class UsePromptBottomSheet extends StatelessWidget {
  final String title;
  final String prompt;
  final String author;
  final String description;
  final String category;
  
  const UsePromptBottomSheet({
    required this.title,
    required this.prompt,
    required this.author,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_left, color: Colors.black,),
                Text(title)
              ],
            ),
            Row(
              children: [
                Text(category),
                Text(' - '),
                Text(author)
              ],
            ),
            Text(description),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Prompt: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(prompt)
              ],
            ),

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