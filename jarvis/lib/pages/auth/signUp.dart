import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/auth/registerForm.dart';
class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

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
                top: 40,
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
                          child: RegisterForm(signUpOnTap: () {}),
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
