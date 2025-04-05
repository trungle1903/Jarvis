import 'package:flutter/material.dart';
import 'emailOptionTile.dart';

class EmailOptions extends StatelessWidget {
  final List<Map<String, dynamic>> emailOptions = [
    {'icon': Icons.thumb_up, 'label': 'Yes'},
    {'icon': Icons.thumb_down, 'label': 'No'},
    {'icon': Icons.tag_faces, 'label': 'Thanks'},
    {'icon': Icons.celebration, 'label': 'Congratulations'},
    {'icon': Icons.sentiment_dissatisfied, 'label': 'Sorry'},
    {'icon': Icons.info_outline, 'label': 'Request for more information'},
    {'icon': Icons.refresh, 'label': 'Follow up'},
  ];

  EmailOptions({
    super.key,
    required Null Function(dynamic option) onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:
                  emailOptions.sublist(0, 4).map((option) {
                    return EmailOptionTile(
                      icon: option['icon'],
                      label: option['label'],
                    );
                  }).toList(),
            ),
            const SizedBox(height: 5),
            Row(
              children:
                  emailOptions.sublist(4, 7).map((option) {
                    return EmailOptionTile(
                      icon: option['icon'],
                      label: option['label'],
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
