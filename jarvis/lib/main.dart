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
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displaySmall: const TextStyle(color: Colors.black),
          displayMedium: const TextStyle(color: Colors.black),
          displayLarge: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          bodySmall: const TextStyle(color: Colors.black),
          bodyMedium: const TextStyle(color: Colors.black),
          bodyLarge: const TextStyle(color: Colors.black),
          titleSmall: const TextStyle(color: Colors.black),
          titleMedium: const TextStyle(color: Colors.black),
          titleLarge: const TextStyle(color: Colors.black),
          
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
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.signIn,
      home: ChatPage(chatName: "Chat"),
    );
  }
}
