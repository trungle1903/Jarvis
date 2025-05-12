import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/knowledge_base/knowledge_soure.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class AssistantKnowledgeDrawer extends StatefulWidget {
  final String assistantId;
  final String assistantName;
  final VoidCallback onClose;

  const AssistantKnowledgeDrawer({
    super.key,
    required this.assistantId,
    required this.assistantName,
    required this.onClose,
  });

  @override
  _AssistantKnowledgeDrawerState createState() => _AssistantKnowledgeDrawerState();
}

class _AssistantKnowledgeDrawerState extends State<AssistantKnowledgeDrawer> {
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assistantProvider = Provider.of<AssistantProvider>(context, listen: false);
      final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
      assistantProvider.fetchAssistantKnowledges(widget.assistantId);
      knowledgeProvider.fetchKnowledges();
    });
  }

  void _refreshAssistantKnowledgeBases() {
    Provider.of<AssistantProvider>(context, listen: false).fetchAssistantKnowledges(widget.assistantId,
      query: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 1,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Knowledge Base for Assistant ${widget.assistantName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (_) => _refreshAssistantKnowledgeBases(),
                            decoration: InputDecoration(
                              hintText: "Search knowledge base...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: jvGrey,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer2<AssistantProvider, KnowledgeBaseProvider>(
                      builder: (context, assistantProvider, knowledgeProvider, child) {
                        if (assistantProvider.isLoading || knowledgeProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator(),);
                        }

                        if (assistantProvider.errorMessage != null) {
                          return Center(child: Text('Error: ${assistantProvider.errorMessage}'),);
                        }

                        if (knowledgeProvider.errorMessage != null) {
                          return Center(child: Text('Error: ${knowledgeProvider.errorMessage}'),);
                        }

                        final knowledges = knowledgeProvider.knowledges;
                        final assistantKnowledges = assistantProvider.assistantKBs;
                        if (knowledges.isEmpty) {
                          return Center(
                            child: Text('No knowledge base found', textAlign: TextAlign.center, style: TextStyle(color: jvSubText),),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: knowledges.length,
                          itemBuilder: (context, index) {
                            final knowledge = knowledges[index];
                            final isImported = assistantKnowledges.any((k) => k.knowledgeName == knowledge.knowledgeName);
                            return Card.outlined(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: jvBlue),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(knowledge.knowledgeName, style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text(knowledge.description, style: TextStyle(fontSize: 12, color: Colors.grey),),
                                trailing: isImported? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Badge(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      label: Text('Imported'),
                                      backgroundColor: jvBlue,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: ()  async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: 
                                            (context) => AlertDialog(
                                              title: Text('Remove Knowledge Base'),
                                              content: Text('Are you sure you want to remove knowledge base from assistant?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false), 
                                                  child: Text('Cancel')
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true), 
                                                  child: Text('Delete')
                                                )
                                              ],
                                            )
                                        );
                                        if (confirm == true) {
                                          await assistantProvider.removeKBFromAssistant(
                                            widget.assistantId,
                                            knowledge.id,
                                          );
                                          await assistantProvider.fetchAssistantKnowledges(
                                            widget.assistantId,
                                          );
                                      }
                                    },
                                    ),
                                  ],
                                ) : IconButton(
                                      icon: const Icon(Icons.add, color: jvBlue),
                                      onPressed: () async {
                                        await assistantProvider.importKBToAssistant(
                                          widget.assistantId,
                                          knowledge.id,
                                        );
                                        await assistantProvider.fetchAssistantKnowledges(
                                          widget.assistantId,
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                        );
                      }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
