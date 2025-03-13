import 'package:flutter/material.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:jarvis/routes/routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
          bodyMedium: const TextStyle(
            color: Colors.black
          ),
          displaySmall: const TextStyle(
            color: Colors.black
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          hoverColor: Colors.blue[100],
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.signIn,
      home: ChatPage(chatName: "Chat"),
    );
  }
}
