import 'package:flutter/material.dart';
import 'package:jarvis/pages/email_page/emailPage.dart';
import 'package:jarvis/pages/forgot_password_page/forgotPassword.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';
import 'package:jarvis/pages/sign_up_page/signUp.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:jarvis/pages/plan_pricing_page/planPricingPage.dart';
import 'package:jarvis/pages/prompt_list_page/promptList.dart';
import 'package:jarvis/pages/personal_page/personalPage.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String planAndPricing = "/planAndPricing";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String promptList = "/promptList";
  static const String forgotPassword = "/resetPassword";

  static final routes = <String, WidgetBuilder>{
    email: (BuildContext context) => EmailPage(),
    signIn: (BuildContext context) => SignInApp(),
    signUp: (BuildContext context) => SignUpApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordApp(),
    chat: (BuildContext context) => ChatPage(),
    personal: (BuildContext context) => PersonalPage(),
    planAndPricing: (BuildContext context) => PlanPricingPage(),
    promptList: (BuildContext context) => PromptApp(),

  };
}
