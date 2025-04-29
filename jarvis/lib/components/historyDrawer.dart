import 'package:flutter/material.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryDrawer extends StatefulWidget {
  const HistoryDrawer({super.key});

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      Future.microtask(() {
        context.read<ChatProvider>().loadHistory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text(
              "Chat History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (chatProvider.error != null) {
                  return Center(child: Text('Error: ${chatProvider.error}'));
                }
                if (chatProvider.history.isEmpty) {
                  return Center(child: Text('History empty'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: chatProvider.history.length,
                  itemBuilder: (context, index) {
                    final conversation = chatProvider.history[index];
                    final isCurrent =
                        conversation.id == chatProvider.conversationId;
                    return _buildHistoryItem(
                      conversation.title,
                      timeago.format(conversation.createdAt),
                      context,
                      isCurrent: isCurrent,
                    );
                  },
                );
              },
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
