import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/buttons.dart';
import 'package:prototype/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user in
  void signIn() async {

    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // display error message
      displayMessage(e.code);
    }
  }

  // display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 20,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.5),
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(
                    'assets/1.png',
                  ),
                )
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF0052CC),
                          width: 3.0,
                        ),
                      ),
                      child: ClipOval(
                          child: Image.asset(
                            'assets/3.png',
                            scale: 0.75,
                          ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Endemand",
                      style: TextStyle(
                        color: Color(0xFF0052CC),
                        fontWeight: FontWeight.w800,
                        fontSize: 30
                      ),
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
                        onTap: signIn,
                        text: "Sign In"
                    ),

                    const SizedBox(
                        height: 25
                    ),
                    // go to register page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Not a member?",
                            style: TextStyle(
                                color: Colors.grey[700]
                            )
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                              "Register now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0052CC)
                              )
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
