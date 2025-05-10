import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/models/unit.dart';
import 'package:jarvis/pages/knowledge_base/create_kb_dialog.dart';
import 'package:jarvis/pages/knowledge_base/edit_kb_dialog.dart';
import 'package:jarvis/pages/knowledge_base/knowledge_unit.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key});

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<KnowledgeBaseProvider>(context, listen: false).fetchKnowledges();
    });
  }

  void _refreshKnowledgeBases() {
    Provider.of<KnowledgeBaseProvider>(context, listen: false).fetchKnowledges(
      query: _searchController.text,
    );
  }

  void _openKnowledgeDrawer(BuildContext context, String id, String title, String description) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Knowledge Drawer',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: KnowledgeUnitDrawer(
            knowledgeBaseId: id,
            title: title,
            description: description,
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideBar(selectedIndex: 2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Knowledge Base",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Search Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _refreshKnowledgeBases(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GradientElevatedButton(
                  onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => CreateKnowledgeBaseDialog(),
                      );
                      if (result) {
                        _refreshKnowledgeBases();
                      }
                    },
                  text: '+  Create Knowledge',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Empty State UI
            Expanded(
              child: Consumer<KnowledgeBaseProvider> (
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator(),);
                  } else if (provider.errorMessage != null) {
                    return Center(child: Text('Error: ${provider.errorMessage}'),);
                  } else if (provider.knowledges.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/imgs/no-results.png", width: 150),
                          const SizedBox(height: 16),
                          const Text(
                            "No knowledge available",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Create your own knowledge",
                              style: TextStyle(fontSize: 16, color: jvBlue),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: provider.knowledges.length,
                      itemBuilder: (context, index) {
                        final kb = provider.knowledges[index];
                        return Card.outlined(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              _openKnowledgeDrawer(context, kb.id, kb.knowledgeName, kb.description);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(kb.knowledgeName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                                      ),
                                      Row(
                                        children: [
                                          IconButton(onPressed: () async {
                                            final result = await showDialog(
                                              context: context, 
                                              builder: 
                                                (context) => EditKnowledgeBaseDialog(knowledge: kb)
                                            );
                                            if (result) {_refreshKnowledgeBases();}
                                          }, icon: Icon(Icons.edit), color: Colors.grey,),
                                          IconButton(onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: 
                                                (context) => AlertDialog(
                                                  title: Text('Delete Knowledge Base'),
                                                  content: Text('Are you sure you want to delete this Knowledge Base?'),
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
                                              await provider.api.deleteKnowledgeBase(kb.id);
                                              _refreshKnowledgeBases();
                                            }
                                          }, icon: Icon(Icons.delete), color: Colors.red,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Text(kb.description ?? 'No description available', style: TextStyle(color: Colors.grey),)
                                ],
                              ),
                            ),
                          )
                        );
                      }
                    );
                  }

                }
              )
            ),
          ],
        ),
      ),
    );
  }
}
