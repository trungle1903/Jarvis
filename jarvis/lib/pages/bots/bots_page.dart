import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/pages/bots/create_bot_dialog.dart';

class BotsPage extends StatefulWidget {
  const BotsPage({super.key});

  @override
  State<BotsPage> createState() => _BotsPageState();
}

class _BotsPageState extends State<BotsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedFilter = "All Bots";
  final List<String> filters = [
    "All Bots",
    "Favorites",
    "Sort by Name",
    "Sort by Date",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideBar(selectedIndex: 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Bots", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
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
                      setState(() {
                        selectedFilter = newValue!;
                      });
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateBotDialog(),
                      );
                    },
                    text: '+  Create Bot',
                  ),
                ],
              ),
            ),

            // Search Bar
            TextField(
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

            // Empty State UI
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/imgs/no-results.png",
                    width: 150,
                  ), // Replace with your asset
                  const SizedBox(height: 10),
                  const Text(
                    "No bots found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
