import 'package:flutter/material.dart';
import 'package:jarvis/pages/promp/createPromptDialog.dart';
import 'package:jarvis/pages/promp/emptyPrompt.dart';
import 'package:jarvis/pages/promp/promptList.dart';
import 'package:jarvis/pages/promp/tabButton.dart';

class PromptLibraryPage extends StatefulWidget {
  const PromptLibraryPage({super.key});

  @override
  State<PromptLibraryPage> createState() => _PromptLibraryPageState();
}

class _PromptLibraryPageState extends State<PromptLibraryPage> {
  int selectedTab = 0;
  int selectedCategoryTab = 0;
  bool showFavoritesOnly = false;

  final List<Map<String, dynamic>> publicPrompts = [
    {
      "title": "Learn Code FAST!",
      "description": "Teach you the code in the simplest way.",
      "category": "Coding",
      "author": "Taylor Swift",
      "prompt": "This is a vip prompt",
      "isFavorite": false,
    },
    {
      "title": "Code Debugging Assistance",
      "description": "Improve your debugging skills.",
      "category": "Coding",
      "author": "Taylor Swift",
      "prompt": "This is a vip prompt",
      "isFavorite": true,
    },
    {
      "title": "SEO Optimization Tips",
      "description": "Boost your website's SEO.",
      "author": "Taylor Swift",
      "prompt": "This is a vip prompt",      
      "category": "SEO",
      "isFavorite": false,
    },
    {
      "title": "Business Plan Writing",
      "description": "Create a professional business plan.",
      "author": "Taylor Swift",
      "prompt": "This is a vip prompt",      
      "category": "Business",
      "isFavorite": true,
    },
  ];

  final List<Map<String, String>> myPrompts = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedPrompts =
        selectedTab == 0 ? publicPrompts : myPrompts;

    List<Map<String, dynamic>> filteredPrompts = selectedPrompts.where((prompt) {
      bool matchesCategory = selectedCategoryTab == 0 ||
          prompt["category"] == _getCategoryName(selectedCategoryTab);
      bool matchesFavorites = !showFavoritesOnly || prompt["isFavorite"] == true;
      return matchesCategory && matchesFavorites;
    }).toList();

    return Drawer(
      backgroundColor: Colors.white,
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
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) => CreatePromptDialog()
                  );
                },
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
                TabButtonWidget(
                  label: "Public Prompts",
                  isSelected: selectedTab == 0,
                  onPressed: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                ),
                const SizedBox(width: 10),
                TabButtonWidget(
                  label: "My Prompts",
                  isSelected: selectedTab == 1,
                  onPressed: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Bar and Star Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    showFavoritesOnly ? Icons.star : Icons.star_border,
                    color: showFavoritesOnly ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      showFavoritesOnly = !showFavoritesOnly;
                    });
                  },
                ),
              ],
            ),
          ),

          // Category Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTabButton("All", 0),
                  _buildCategoryTabButton("Marketing", 1),
                  _buildCategoryTabButton("Business", 2),
                  _buildCategoryTabButton("SEO", 3),
                  _buildCategoryTabButton("Coding", 4),
                  _buildCategoryTabButton("Writing", 5),
                ],
              ),
            ),
          ),

          Expanded(
            child: filteredPrompts.isEmpty
                ? EmptyPromptWidget(
                    onCreatePrompt: () {},
                  )
                : PromptListWidget(
                    prompts: filteredPrompts,
                    onPromptSelected: () {},
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabButton(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategoryTab == index ? Colors.blue : Colors.grey[300],
          foregroundColor: selectedCategoryTab == index ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          setState(() {
            selectedCategoryTab = index;
          });
        },
        child: Text(label),
      ),
    );
  }

  String _getCategoryName(int index) {
    switch (index) {
      case 1:
        return "Marketing";
      case 2:
        return "Business";
      case 3:
        return "SEO";
      case 4:
        return "Coding";
      case 5:
        return "Writing";
      default:
        return "All";
    }
  }
}