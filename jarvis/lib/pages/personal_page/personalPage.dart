import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/pages/personal_page/widgets/searchBarWidget.dart';
import 'package:jarvis/pages/personal_page/widgets/dropdownWidget.dart';
import 'package:jarvis/pages/personal_page/widgets/noBotPanel.dart';
import 'package:jarvis/pages/personal_page/widgets/noKnowledgePanel.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: HistoryDrawer(),
      body: Column(
        children: [
          TabBar(
            indicatorColor: Colors.blue[400],
            labelStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800),
            controller: _tabController,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesomeIcons.robot, color: Colors.blue[400]),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Text("Bots"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.database, color: Colors.blue[400]),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Text("Knowledge"),
                  ],
                ),
              ),
            ],
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildBotTab(context),
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(onSearch: (value) => {}),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueAccent,
                        ),
                        child: TextButton(
                          onPressed: () => {},
                          child: SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.add_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  style: GoogleFonts.jetBrainsMono(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  "Create  knowledge",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: NoKnowledgePanel()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildBotTab(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DropdownWidget(
                display: "Type:",
                types: ["All", "Published", "Favorites"],
                onSelect: (m) => {},
              ),
            ),
            Expanded(child: SearchBarWidget(onSearch: (searchVal) => {})),
            const SizedBox(width: 8.0),
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueAccent,
            ),
            child: TextButton(
              onPressed: () => {},
              child: SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Text(
                      "Create  bot",
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: NoBotPanel()),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Text(
        "Personal",
        style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800),
      ),
    );
  }
}
