import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class KnowledgeSourceDialog extends StatelessWidget {
  final List<Map<String, dynamic>> sources = [
    {"title": "Local files", "subtitle": "Upload pdf, docx, ...", "icon": Icons.insert_drive_file},
    {"title": "Website", "subtitle": "Connect Website to get data", "icon": Icons.language},
    {"title": "Google Drive", "subtitle": "Connect to Google Drive", "icon": Icons.cloud},
    {"title": "Slack", "subtitle": "Connect to Slack workspace", "icon": Icons.message},
    {"title": "Confluence", "subtitle": "Connect to Confluence", "icon": Icons.business},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,  
          maxHeight: 500, 
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Knowledge Source",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: sources.map((source) {
                      return ListTile(
                        leading: Icon(source["icon"], color: jvBlue),
                        title: Text(
                          source["title"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        subtitle: Text(
                              source["subtitle"],
                              style: TextStyle(color: Colors.grey),
                            ),
                        onTap: () {},
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}