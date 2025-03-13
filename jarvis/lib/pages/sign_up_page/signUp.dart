import 'package:flutter/material.dart';
import 'package:jarvis/routes/routes.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.signIn,
      home: ChatPage(chatName: "Chat"),
    );
  }
}
