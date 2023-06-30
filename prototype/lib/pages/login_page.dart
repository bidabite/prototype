import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/pages/components/buttons.dart';
import 'package:prototype/pages/components/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                    height: 50
                ),
                // welcome back
                Text(
                  "Welcome back, you've been missed",
                  style: TextStyle(
                      color: Colors.grey[700]
                  )
                ),
                const SizedBox(
                    height: 25
                ),
                // email textfield
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obscureText: false
                ),

                const SizedBox(
                    height: 10
                ),

                // password textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obscureText: true
                ),

                const SizedBox(
                    height: 25
                ),

                // sign in button
                MyButton(
                  onTap: (){},
                  text: "Sign In"
                ),

                const SizedBox(
                    height: 25
                ),
                // go to register page
                GestureDetector(
                  onTap: (){

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                            color: Colors.grey[700]
                        )
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
