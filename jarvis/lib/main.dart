import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jarvis/providers/assistants_provider.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:jarvis/providers/chat_provider.dart';
import 'package:jarvis/providers/email_provider.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:jarvis/providers/prompt_provider.dart';
import 'package:jarvis/routes/routes.dart';
import 'package:jarvis/services/ad_manager.dart';
import 'package:jarvis/services/api/assistants_api_service.dart';
import 'package:jarvis/services/api/chat_api_service.dart';
import 'package:jarvis/services/api/email_api_service.dart';
import 'package:jarvis/services/api/kb_api_service.dart';
import 'package:jarvis/services/api/prompt_api_service.dart';
import 'package:jarvis/services/header_service.dart';
import 'package:jarvis/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final dio = Dio();
  final storageService = StorageService();
  final headerService = await HeaderService.initialize();

  final authProvider = AuthProvider(
    storageService: storageService,
    headerService: headerService,
    dio: dio,
  );
  await authProvider.initialize();
  AuthProvider.setupDioInterceptor(dio, authProvider);
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['F8B59E765BFB50B31FE7B802F24700FE'])
    );
    AdManager.loadInterstitialAd();
  }
  runApp(
    MultiProvider(
      providers: [
        Provider<PromptApiService>(
          create:
              (_) => PromptApiService(dio: dio, headerService: headerService),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                storageService: storageService,
                headerService: headerService,
                dio: dio,
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ChatProvider(
                ChatApiService(dio: dio, headerService: headerService),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PromptProvider(
                PromptApiService(dio: dio, headerService: headerService),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AssistantProvider(
                AssistantApiService(dio: dio, headerService: headerService),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => KnowledgeBaseProvider(
                KnowledgeBaseApiService(dio: dio, headerService: headerService),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => EmailProvider(
                EmailApiService(dio: dio, headerService: headerService),
              ),
        ),
      ],
      child: MyApp(),
    ),
  );
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
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
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
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          contentTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.signIn,
    );
  }
}
