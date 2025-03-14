import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class KnowledgeSourceDialog extends StatelessWidget {
  final List<Map<String, dynamic>> sources = [
    {"title": "Local files", "subtitle": "Upload pdf, docx, ...", "icon": Icons.insert_drive_file, "enabled": true},
    {"title": "Website", "subtitle": "Connect Website to get data", "icon": Icons.language, "enabled": true},
    {"title": "Google Drive", "subtitle": "Connect to Google Drive", "icon": Icons.cloud, "enabled": false},
    {"title": "Slack", "subtitle": "Connect to Slack workspace", "icon": Icons.message, "enabled": false},
    {"title": "Confluence", "subtitle": "Connect to Confluence", "icon": Icons.business, "enabled": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,  
          minHeight: 500, 
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
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
                      leading: Icon(source["icon"], color: source["enabled"] ? jvBlue : Colors.grey),
                      title: Text(
                        source["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: source["enabled"] ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          if (!source["enabled"])
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Coming soon",
                                style: TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ),
                          if (!source["enabled"]) SizedBox(width: 8),
                          Text(
                            source["subtitle"],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      enabled: source["enabled"],
                      onTap: source["enabled"] ? () {} : null,
                    );
                  }).toList(),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ]
        )
      ),
    );
  }
}
