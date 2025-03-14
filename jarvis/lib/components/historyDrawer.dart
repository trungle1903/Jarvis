import 'package:flutter/material.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text("Chat History"),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildHistoryItem(
                  "Dumb dumb chat 0",
                  "30 minutes ago",
                  context,
                ),
                _buildHistoryItem(
                  "Dumb dumb chat 1",
                  "4 hours ago",
                  context,
                  isCurrent: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String title,
    String time,
    BuildContext context, {
    bool isCurrent = false,
  }) {
    return Card(
      color: isCurrent ? Colors.blue.shade100 : null,
      child: ListTile(
        leading:
            isCurrent
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Current",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
                : null,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(time),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
