import 'package:flutter/material.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: SignUpForm()));
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pwordController = TextEditingController();
  final TextEditingController _cpwordController = TextEditingController();

  String _uname = '';
  String _pword = '';
  String _cpword = '';
  String _email = '';

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(
        'Uname:  $_uname, Password: $_pword, Confirm Password: $_cpword, Email: $_email',
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Step AI',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  //Username field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You have to enter your username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _uname = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  //Password field
                  TextFormField(
                    controller: _pwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You have to enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _pword = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  //Confirm password field
                  TextFormField(
                    controller: _cpwordController,
                    decoration: InputDecoration(labelText: 'Confirm password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You have to confirm your password';
                      } else if (value != _pwordController.text) {
                        //print('$value, password: ' + _pwordController.text);
                        return 'Password do not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _cpword = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  //Email field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You have to enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF373FA9),
                      foregroundColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Sign up'),
                  ),
                  SizedBox(height: 16),
                  //Switch to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => ToLogin(context),
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 14, color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ToLogin(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (content) => SignInApp()),
  );
}
