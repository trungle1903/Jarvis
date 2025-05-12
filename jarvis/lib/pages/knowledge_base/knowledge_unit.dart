import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/knowledge_base/knowledge_soure.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class KnowledgeUnitDrawer extends StatefulWidget {
  final String knowledgeBaseId;
  final String title;
  final String description;
  final VoidCallback onClose;

  const KnowledgeUnitDrawer({
    super.key,
    required this.knowledgeBaseId,
    required this.title,
    required this.description,
    required this.onClose,
  });

  @override
  _KnowledgeUnitDrawerState createState() => _KnowledgeUnitDrawerState();
}

class _KnowledgeUnitDrawerState extends State<KnowledgeUnitDrawer> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
      provider.fetchKnowledgeUnits(widget.knowledgeBaseId);
    });
  }

  IconData _getIconForUnitType(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
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
                widget.title,
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
                    Text(widget.description, style: const TextStyle(color: jvSubText, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search units...",
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
                              Provider.of<KnowledgeBaseProvider>(context, listen: false)
                                  .searchUnits(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        GradientElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => KnowledgeSourceDialog(knowledgeBaseId: widget.knowledgeBaseId),
                            ).then((_) {
                              Provider.of<KnowledgeBaseProvider>(context, listen: false).fetchKnowledgeUnits(widget.knowledgeBaseId);
                            });
                          },
                          text: "+ Add",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer<KnowledgeBaseProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(child: CircularProgressIndicator(),);
                        }

                        if (provider.errorMessage != null) {
                          return Center(child: Text('Error: ${provider.errorMessage}'),);
                        }

                        final units = provider.units;
                        if (units.isEmpty) {
                          return Center(
                            child: Text('No units found', textAlign: TextAlign.center, style: TextStyle(color: jvSubText),),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            final unit = units[index];
                            return Card.outlined(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: jvBlue),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Icon(_getIconForUnitType(unit.type), color: jvDeepBlue),
                                title: Text(unit.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Text("${unit.size.toStringAsFixed(2)} KB", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Switch(
                                      activeColor: jvBlue,
                                      value: unit.enabled,
                                      onChanged: (value) {
                                        provider.toggleUnitEnabled(widget.knowledgeBaseId, unit.id, value);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: ()  async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: 
                                            (context) => AlertDialog(
                                              title: Text('Delete Knowledge Base'),
                                              content: Text('Are you sure you want to delete this unit?'),
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
                                        await provider.deleteUnit(widget.knowledgeBaseId, unit.id);
                                        provider.fetchKnowledgeUnits(widget.knowledgeBaseId);
                                      }
                                    },
                                    ),
                                  ],
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
