import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/auth/forgotPassword.dart';
import 'package:jarvis/pages/auth/signUp.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback signUpOnTap;

  const LoginForm({required this.signUpOnTap});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _uname = '';
  String _pword = '';

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400), 
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpApp()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: jvDeepBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {},
                icon: Image.asset(
                  'assets/logos/google.png',
                  width: 24,  
                  height: 24,
                ),
                label: Text('Sign in with Google', style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: jvLightGrey, width: 1)),
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: jvDeepBlue, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: jvDeepBlue, width: 1),)
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'You have to enter your email.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _uname = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: jvDeepBlue, fontWeight: FontWeight.bold),
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: jvDeepBlue, width: 1),)
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'You have to enter your password.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pword = value!;
                },
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordApp()),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: jvDeepBlue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: submit,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: jvDeepBlue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}