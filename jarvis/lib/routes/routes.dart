import 'package:flutter/material.dart';
import 'package:jarvis/pages/bots_page.dart';
import 'package:jarvis/pages/email_page/emailPage.dart';
import 'package:jarvis/pages/forgot_password_page/forgotPassword.dart';
import 'package:jarvis/pages/group_page.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';
import 'package:jarvis/pages/sign_up_page/signUp.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:jarvis/pages/plan_pricing_page/planPricingPage.dart';

class Routes {
  Routes._();

  static const String chat = '/chat';
  static const String bots = '/bots';
  static const String groups = '/groups';
  static const String email = '/email';
  static const String planAndPricing = "/planAndPricing";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/resetPassword";

  static final routes = <String, WidgetBuilder>{
    chat: (BuildContext context) => ChatPage(),
    bots: (BuildContext context) => BotsPage(),
    groups: (BuildContext context) => GroupManagementPage(),
    email: (BuildContext context) => EmailPage(),
    signIn: (BuildContext context) => SignInApp(),
    signUp: (BuildContext context) => SignUpApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordApp(),
    planAndPricing: (BuildContext context) => PlanPricingPage(),
  };
}
