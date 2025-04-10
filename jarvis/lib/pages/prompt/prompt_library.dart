import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/prompt/createPromptDialog.dart';
import 'package:jarvis/pages/prompt/emptyPrompt.dart';
import 'package:jarvis/pages/prompt/promptList.dart';
import 'package:jarvis/pages/prompt/tabButton.dart';
import 'package:jarvis/providers/prompt_provider.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';
import 'package:provider/provider.dart';

class PromptLibraryPage extends StatefulWidget {
  const PromptLibraryPage({super.key});

  @override
  State<PromptLibraryPage> createState() => _PromptLibraryPageState();
}

class _PromptLibraryPageState extends State<PromptLibraryPage> {
  int selectedTab = 0;
  int selectedCategoryTab = 0;
  bool showFavoritesOnly = false;
  String searchQuery = '';
  bool isLoading = false;
  bool isInitialized = false;

  final Map<int, String> categoryMap = {
    0: 'all',
    1: 'business',
    2: 'career',
    3: 'chatbot',
    4: 'coding',
    5: 'education',
    6: 'fun',
    7: 'marketing',
    8: 'productivity',
    9: 'seo',
    10: 'writing',
    11: 'other'
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) { 
    isInitialized = true;
    _loadPrompts();
  }
  }

  Future<void> _loadPrompts() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final promptProvider = Provider.of<PromptProvider>(context, listen: false);
      if (selectedTab == 0) {
        await promptProvider.loadPrompts(
          query: searchQuery,
          category: categoryMap[selectedCategoryTab],
          isFavorite: showFavoritesOnly ? true : null,
        );
      } else {
        await promptProvider.loadPrompts(query: searchQuery);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading prompts: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final promptProvider = Provider.of<PromptProvider>(context);
    
    final prompts = selectedTab == 0 
      ? promptProvider.publicPrompts
      : promptProvider.myPrompts;

    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
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
                onPressed: () => _showCreatePromptDialog()
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
                    _loadPrompts();
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
                    _loadPrompts();
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
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                      _loadPrompts();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                if (selectedTab == 0)
                IconButton(
                  icon: Icon(
                    showFavoritesOnly ? Icons.star : Icons.star_border,
                    color: showFavoritesOnly ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      showFavoritesOnly = !showFavoritesOnly;
                    });
                    _loadPrompts();
                  },
                ),
              ],
            ),
          ),

          // Category Tabs
          if (selectedTab == 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTabButton("All", 0),
                  _buildCategoryTabButton("Business", 1),
                  _buildCategoryTabButton("Career", 2),
                  _buildCategoryTabButton("Chatbot", 3),
                  _buildCategoryTabButton("Coding", 4),
                  _buildCategoryTabButton("Education", 5),
                  _buildCategoryTabButton("Fun", 6),
                  _buildCategoryTabButton("Marketing", 7),
                  _buildCategoryTabButton("Productivity", 8),
                  _buildCategoryTabButton("SEO", 9),
                  _buildCategoryTabButton("Writing", 10),
                  _buildCategoryTabButton("Other", 11),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : prompts.isEmpty
                ? EmptyPromptWidget(
                    onCreatePrompt: _showCreatePromptDialog,
                  )
                : PromptListWidget(
                    prompts: prompts,
                    onPromptSelected: (prompt) {
                      Navigator.pop(context, prompt);
                    },
                    onFavoriteToggled: (promptId) {},
                    isMyPromptTab: selectedTab == 1,
                    apiService: promptProvider.api,
                    onReload: _loadPrompts,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabButton(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedCategoryTab == index,
        onSelected: (_) {
          setState(() => selectedCategoryTab = index);
          _loadPrompts();
        },
        selectedColor: jvBlue,
        labelStyle: TextStyle(color: selectedCategoryTab == index ? Colors.white : Colors.black),
        avatar: null,
      ),
    );
  }

 void _showCreatePromptDialog() {
  showDialog(
    context: context, 
    builder: (context) {
      final promptProvider = Provider.of<PromptProvider>(context, listen: false);
      final apiService = promptProvider.api;
      return CreatePromptDialog(
        apiService: apiService,
        onCreate: (newPrompt) {
          promptProvider.addPrompt(newPrompt);
        },
      );
    }
  );
 }
}