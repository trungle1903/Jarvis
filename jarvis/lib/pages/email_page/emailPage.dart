import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/components/dropdownAI.dart';
import 'package:jarvis/pages/email_page/widgets/emailOptions.dart';
import 'package:jarvis/components/messageTile.dart';

import '../../components/chatBar.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<MessageTile> messages = [];
  final List<Map<String, String>> _aiModels = [
    {'name': 'Gemini 1.5 Flash', 'logo': 'lib/core/assets/imgs/gemini.png'},
    {'name': 'Chat GPT 4o', 'logo': 'lib/core/assets/imgs/gpt.png'},
  ];
  String _currentModelPathLogo = "lib/core/assets/imgs/gpt.png";

  void onSendMessage(String sendMessage) {
    setState(() {
      messages.add(MessageTile(isAI: false, message: sendMessage));
      messages.add(
        MessageTile(isAI: true, message: "OK", aiLogo: _currentModelPathLogo),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Email Generator",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
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
            //EmailOptionTile(icon: Icons.abc_sharp,label: "ABC",onTap: (){},)

            //EmailOptions(),
            // ChatBar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmailOptions(),
                const SizedBox(height: 5),
                // ChatBar(),
                // DropdownAI(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: ChatBar(onSendMessage: onSendMessage)),
                      const SizedBox(width: 10),
                      DropdownAI(
                        aiModels: _aiModels,
                        onChange: (nameModel) {
                          _currentModelPathLogo =
                              _aiModels.firstWhere(
                                (element) => element['name'] == nameModel,
                              )['logo']!;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
