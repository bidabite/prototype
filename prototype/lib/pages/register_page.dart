import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // sign user up
  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    // make sure passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      // pop loading circle
      Navigator.pop(context);
      // show error to user
      displayMessage("Passwords don't match!");
      return;
    }

    // try creating the user
    try {

      // create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);

      // after creating the user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'username': emailTextController.text.split('@')[0], // initial username
        'bio': 'Empty bio..', // initiall empty bio
        'image': "https://firebasestorage.googleapis.com/v0/b/enstacksolution.appspot.com/o/business-people-meeting-vector-flat-design1.jpg?alt=media&token=44903e20-5eed-42cf-b2a8-eb771909e8fd"
      });

      // pop loading circle
      if (context.mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      // show error to user
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
      backgroundColor: Colors.white,
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
                        "Let's create an account for you",
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
                        height: 10
                    ),

                    // confirm password textfield
                    MyTextField(
                        controller: confirmPasswordTextController,
                        hintText: "Confirm Password",
                        obscureText: true
                    ),

                    const SizedBox(
                        height: 25
                    ),

                    // sign up button
                    MyButton(
                        onTap: signUp,
                        text: "Sign Up"
                    ),

                    const SizedBox(
                        height: 25
                    ),
                    // go to register page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: Colors.grey[700]
                            )
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                              "Login now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0052CC)
                              )
                          ),
                        )
                      ],
                    )
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
