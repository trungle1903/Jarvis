import 'package:flutter/material.dart';
import 'package:jarvis/pages/assistants/assistants_page.dart';
import 'package:jarvis/pages/email_page/emailPage.dart';
import 'package:jarvis/pages/auth/forgotPassword.dart';
import 'package:jarvis/pages/group_page.dart';
import 'package:jarvis/pages/auth/signIn.dart';
import 'package:jarvis/pages/auth/signUp.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:jarvis/pages/pricing_page/pricingPage.dart';
import 'package:jarvis/services/auth_guard.dart';

class Routes {
  Routes._();

  static const String chat = '/chat';
  static const String bots = '/bots';
  static const String groups = '/groups';
  static const String email = '/email';
  static const String pricing = "/pricing";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/resetPassword";

  static final routes = <String, WidgetBuilder>{
    chat: (BuildContext context) => AuthGuard(child: ChatPage()),
    bots: (BuildContext context) => AuthGuard(child: AssistantsPage()),
    groups: (BuildContext context) => AuthGuard(child: GroupManagementPage()),
    email: (BuildContext context) => AuthGuard(child: EmailPage()),
    signIn: (BuildContext context) => SignInApp(),
    signUp: (BuildContext context) => SignUpApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordApp(),
    pricing: (BuildContext context) => AuthGuard(child: PricingPage()),
  };
}
