import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:medotg/components/my_button.dart';
import 'package:medotg/components/my_textfield.dart';

import '../../signup/sign_up.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String _errorMessage = "";

  void signUserIn() async {
    try {
      // Log in using email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    // Display a dialog with an error message
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      // Validate if email is empty
      setState(() {
        _errorMessage = "Email cannot be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      // Validate if email is invalid
      setState(() {
        _errorMessage = "Email address is invalid";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          reverse: true,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor("#ffffff"),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#4f4f4f"),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      onChanged: (() {
                                        validateEmail(emailController.text);
                                      }),
                                      controller: emailController,
                                      hintText: "enter your email",
                                      obscureText: false,
                                      prefixIcon: const Icon(Icons.mail_outline),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        _errorMessage,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyTextField(
                                      controller: passwordController,
                                      hintText: "**************",
                                      obscureText: true,
                                      prefixIcon: const Icon(Icons.lock_outline),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MyButton(
                                      onPressed: signUserIn,
                                      buttonText: 'Submit',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Text("Don't have an account yet?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#8d8d8d"),
                                              )),
                                          TextButton(
                                            child: Text(
                                              "Sign Up",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: HexColor("#44564a"),
                                              ),
                                            ),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUpScreen(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -253),
                        child: Image.asset(
                          'assets/Images/plants2.png',
                          scale: 1.5,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
