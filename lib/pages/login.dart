// login.dart

import 'package:ecommerce/pages/forgotpassword.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/widgets/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottomnav.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpassswordcontroller = TextEditingController();

  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: TextStyle(fontSize: 18.0))),
      );
    }
  }

  @override
  void dispose() {
    useremailcontroller.dispose();
    userpassswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              // first part orange
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFc7ddb6),
                        Color(0xFFff5c30),
                        // Colors.black
                      ]),
                  // color: Colors.black,
                  // color: Color(0xcFFbcc1b8),
                ),
              ),

              // second part
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Text(''),
              ),

              // app logo and login
              Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset('images/Snack.png',
                            width: MediaQuery.of(context).size.width / 1.5,
                            fit: BoxFit.cover)),
                    SizedBox(height: 50.0),
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.only(right: 20.0, left: 10),
                        width: MediaQuery.of(context).size.width,
                        // white card
                        height: MediaQuery.of(context).size.height / 1.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        // Login Fields
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(height: 30.0),
                              // Login Text
                              Text('Login',
                                  style: AppWidget.HeadlineTextFieldStyle()),

                              SizedBox(height: 30.0),
                              // Email field
                              Container(
                                padding: EdgeInsets.all(18),
                                child: TextFormField(
                                  controller: useremailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the email';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: AppWidget.semiTextFieldStyle(),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              // Password field
                              Container(
                                padding: EdgeInsets.all(18),
                                child: TextFormField(
                                  controller: userpassswordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: AppWidget.semiTextFieldStyle(),
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              // Forgot password field
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 18),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text('Forget Password?',
                                        style: AppWidget.semiTextFieldStyle()),
                                  ),
                                ),
                              ),

                              SizedBox(height: 40.0),

                              // Login button
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 70.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          email = useremailcontroller.text;
                                          password =
                                              userpassswordcontroller.text;
                                        });
                                        userLogin();
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Color(0xffff5722)),
                                      elevation:
                                          WidgetStateProperty.all<double>(15.0),
                                    ),
                                    child: Text('LOGIN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontFamily: 'Poppins1',
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Text('Don\'t have an account? Sign up',
                            style: AppWidget.semiTextFieldStyle()),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
