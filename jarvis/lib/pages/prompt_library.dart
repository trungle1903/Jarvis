import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const PromptLibraryPage(),
    );
  }
}

class PromptLibraryPage extends StatefulWidget {
  const PromptLibraryPage({super.key});

  @override
  State<PromptLibraryPage> createState() => _PromptLibraryPageState();
}

class _PromptLibraryPageState extends State<PromptLibraryPage> {
  int selectedTab = 0;

  final List<Map<String, String>> publicPrompts = [
    {
      "title": "Learn Code FAST!",
      "description": "Teach you the code in the simplest way.",
    },
    {
      "title": "Code Debugging Assistance",
      "description": "Improve your debugging skills.",
    },
    {
      "title": "Code Optimization",
      "description": "Optimize your code using best practices.",
    },
  ];

  final List<Map<String, String>> myPrompts = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> selectedPrompts =
        selectedTab == 0 ? publicPrompts : myPrompts;

    return Drawer(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          AppBar(
            title: const Text(
              "Prompt Library",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("Public Prompts", 0),
                const SizedBox(width: 10),
                _buildTabButton("My Prompts", 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child:
                selectedPrompts.isEmpty
                    ? _buildEmptyState()
                    : _buildPromptList(selectedPrompts),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTab == index ? Colors.blue : Colors.grey[300],
        foregroundColor: selectedTab == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Text(label),
    );
  }

  Widget _buildPromptList(List<Map<String, String>> prompts) {
    return ListView.builder(
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            prompts[index]["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(prompts[index]["description"]!),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/imgs/no-results.png", height: 150),
        const SizedBox(height: 10),
        const Text(
          "No prompts found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Create your own prompt",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
