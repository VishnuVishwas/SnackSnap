import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../widgets/widget_support.dart';
import 'bottomnav.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Email, Mail, Password variables
  String email = "", password = "", name = "";

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();

  // check for all fields in textfield
  final _formkey = GlobalKey<FormState>();

  // approve user or reject
  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            content: Text('Registered Successfully',
                style: TextStyle(fontSize: 20.0)),
            backgroundColor: Colors.redAccent)));

        // upload to firebase
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          'Name': namecontroller.text,
          'Email': emailcontroller.text,
          'Wallet': '0',
          'Id': Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPrefeneceHelper().saveUserName(namecontroller.text);
        await SharedPrefeneceHelper().saveUserEmail(emailcontroller.text);
        await SharedPrefeneceHelper().saveUserWallet('0');
        await SharedPrefeneceHelper().saveUserId(Id);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      }
      // if weak-pass or email exists
      on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Password Provided is too Weak',
                  style: TextStyle(fontSize: 18.0)),
              backgroundColor: Colors.orangeAccent));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Account Already exists',
                style: TextStyle(fontSize: 18.0)),
            backgroundColor: Colors.orangeAccent,
          ));
        }
      }
    }
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

              //app logo and login
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
                        height: MediaQuery.of(context).size.height / 1.6,
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
                              Text('Sign up',
                                  style: AppWidget.HeadlineTextFieldStyle()),

                              SizedBox(height: 30.0),
                              // username
                              Container(
                                padding: EdgeInsets.all(18),
                                child: TextFormField(
                                  controller: namecontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter your Name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: AppWidget.semiTextFieldStyle(),
                                    prefixIcon: Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              // Email field
                              Container(
                                padding: EdgeInsets.all(18),
                                child: TextFormField(
                                  controller: emailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter E-mail';
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

                              //password
                              Container(
                                padding: EdgeInsets.all(18),
                                child: TextFormField(
                                  controller: passwordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
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
                                          email = emailcontroller.text;
                                          name = namecontroller.text;
                                          password = passwordcontroller.text;
                                        });
                                        registration();
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Color(0xffff5722)),
                                      elevation:
                                          WidgetStateProperty.all<double>(15.0),
                                    ),
                                    child: Text('SIGN UP',
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
                                builder: (context) => const LogIn()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 45),
                        child: Text('Already have an account? Login',
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
