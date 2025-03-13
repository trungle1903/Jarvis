import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/components/messageTile.dart';
import 'package:jarvis/pages/personal_page/personalPage.dart';
import 'package:jarvis/pages/personal_page/widgets/dropdownWidget.dart';

import 'package:jarvis/components/appNameWidget.dart';
import '../../components/chatBar.dart';
import '../../components/historyDrawer.dart';
import '../../routes/routes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  List<MessageTile> messages = [];
  final List<Map<String, String>> _aiModels = [
    {
      'name': 'Gemini 1.5 Flash',
      'logo': 'lib/core/assets/imgs/gemini.png'
    },
    {'name': 'Chat GPT 4o', 'logo': 'lib/core/assets/imgs/gpt.png'},
  ];
  String _currentModelPathLogo = "lib/core/assets/imgs/gpt.png";

  void onSendMessage(String sendMessage) {
    setState(() {
      messages.add(MessageTile(
          isAI: false, message: sendMessage));
      messages.add(MessageTile(isAI: true, message: "OK",logoAI: _currentModelPathLogo ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HistoryDrawer(),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.chatName??"Chat", style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.width * 0.05),),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                        child: DropdownAI(aiModels: _aiModels, onChange: (nameModel){
                          _currentModelPathLogo = _aiModels.firstWhere((element) => element['name'] == nameModel)['logo']!;
                        }),
                        )
                    ),
                  const SizedBox(height: 8),
                  ChatBar(onSendMessage: onSendMessage,),
                  const SizedBox(height: 20,),
                ],
              ),
            ],
          )),
    );
  }
}
