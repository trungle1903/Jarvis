import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/auth/forgotPassword.dart';
import 'package:jarvis/pages/auth/signUp.dart';
import 'package:jarvis/pages/chat_page/chatPage.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback signUpOnTap;

  const LoginForm({required this.signUpOnTap});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                        color: jvDeepBlue,
                        fontWeight: FontWeight.bold,
                      ),
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
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: jvLightGrey, width: 1),
                  ),
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
                  floatingLabelStyle: TextStyle(
                    color: jvDeepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: jvDeepBlue, width: 1),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                controller: _usernameController,
                keyboardType: TextInputType.text,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(
                    color: jvDeepBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: jvDeepBlue, width: 1),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
              ),
              if (authProvider.error != null)
                Text(authProvider.error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordApp(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: jvDeepBlue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              authProvider.isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await authProvider.login(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          if (authProvider.isAuthenticated) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/chat',
                              (Route<dynamic> route) => false,
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Login failed: ${e.toString()}'),
                            ),
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: jvDeepBlue,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
