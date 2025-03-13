import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/forgot_password_page/forgotPassword.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:jarvis/pages/sign_up_page/signUp.dart';
class SignInApp extends StatelessWidget {
  const SignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logos/jarvis.png', 
                      height: 40, 
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Jarvis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: jvDeepBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (width > 700) 
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            'Welcome\nto Jarvis',
                            style: TextStyle(
                              fontSize: 48,
                              color: jvDeepBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Jarvis is here to streamline your online\nexperience, let\'s get started!',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: jvSubText),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.desktop_windows_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.phone_android,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.message_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.android,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 80, 
                                height: 80, 
                                decoration: BoxDecoration(
                                  color: jvDeepBlue, 
                                  shape: BoxShape.rectangle, 
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.apple,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                  iconSize: 50,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                        ),
                      )
                  ),
                ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: jvGrey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: jvDeepBlue,
                              width: 0.5,
                              style: BorderStyle.solid
                            )
                          ),
                          child: LoginForm(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
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
                  onTap: signUpOnTap,
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
                  borderSide: BorderSide(color:jvDeepBlue, width: 1),)
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
                  borderSide: BorderSide(color:jvDeepBlue, width: 1),)
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
                  style: TextStyle(color:jvDeepBlue),
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
    );
  }

  void signUpOnTap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpApp()),
    );
  }
}
