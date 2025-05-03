import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/pages/assistants/create_assistant_dialog.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:provider/provider.dart';

class AssistantsPage extends StatefulWidget {
  const AssistantsPage({super.key});

  @override
  State<AssistantsPage> createState() => _AssistantsPageState();
}

class _AssistantsPageState extends State<AssistantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedFilter = "All";
  final List<String> filters = [
    "All",
    "Favorites",
    "Sort by Name",
    "Sort by Date",
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AssistantProvider>(context, listen: false).fetchAssistants();
    });
  }

  void _refreshAssistants() {
    Provider.of<AssistantProvider>(context, listen: false).fetchAssistants(
      query: _searchController.text,
      isFavorite: selectedFilter == "Favorites" ? true : null,
      order: selectedFilter == "Sort by Name" ? 'ASC' : null,
      orderField:
          selectedFilter == "Sort by Name"
              ? 'assistantName'
              : selectedFilter == "Sort by Date"
              ? 'createdAt'
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideBar(selectedIndex: 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Assistants", style: TextStyle(color: Colors.black)),
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
            // Filters & Create Bot Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dropdown for sorting/filtering
                  DropdownButton<String>(
                    value: selectedFilter,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFilter = newValue;
                        });
                        _refreshAssistants();
                      }
                    },
                    items:
                        filters.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),

                  // Create Bot Button
                  GradientElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => CreateAssistantDialog(),
                      );
                      if (result) {
                        _refreshAssistants();
                      }
                    },
                    text: '+  Create Bot',
                  ),
                ],
              ),
            ),

            // Search Bar
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                _refreshAssistants();
              },
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Assistant List
            Expanded(
              child: Consumer<AssistantProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.errorMessage != null) {
                    return Center(
                      child: Text('Error: ${provider.errorMessage}'),
                    );
                  } else if (provider.assistants.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/imgs/no-results.png", width: 150),
                        SizedBox(height: 10),
                        Text(
                          "No assistans found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: provider.assistants.length,
                      itemBuilder: (context, index) {
                        final assistant = provider.assistants[index];
                        return Card.outlined(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      assistant.assistantName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Divider(
                                      height: 6,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  assistant.instructions,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
