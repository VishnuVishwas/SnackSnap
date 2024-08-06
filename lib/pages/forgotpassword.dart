// forgotpassword.dart

import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Reset Email has been sent!')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for the email')));
      }
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30.0),
              // heading
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  'Password Recovery',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),

              //Enter your mail
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  'Enter your mail',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 60.0),

              // Email section
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TextFormField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 28.0, right: 10.0),
                          child: Icon(Icons.person, color: Colors.white70),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.0),

              // send email
              GestureDetector(
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    resetPassword();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(14),
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child:
                      Text('Send Email', style: AppWidget.semiTextFieldStyle()),
                ),
              ),
              SizedBox(height: 50.0),

              // Signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: TextStyle(color: Colors.white70, fontSize: 17.0)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: Text(' Create',
                        style: TextStyle(
                            color: Color.fromARGB(225, 184, 166, 1),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
