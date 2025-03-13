import 'package:flutter/material.dart';
import 'package:jarvis/pages/email_page/emailPage.dart';
import 'package:jarvis/pages/forgot_password_page/forgotPassword.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';
import 'package:jarvis/pages/sign_up_page/signUp.dart';

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
  };
}
