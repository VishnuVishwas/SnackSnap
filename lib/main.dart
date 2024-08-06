import 'package:ecommerce/admin/add_food.dart';
import 'package:ecommerce/admin/admin_login.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin/home_admin.dart';
import 'firebase_options.dart';

import 'pages/bottomnav.dart';
import 'pages/forgotpassword.dart';
import 'pages/home.dart';
import 'pages/onboard.dart';
import 'pages/order.dart';
import 'pages/splash_screen.dart';
import 'pages/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
