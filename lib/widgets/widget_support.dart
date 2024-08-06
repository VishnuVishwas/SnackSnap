import 'package:flutter/material.dart';

class AppWidget {
  // bold text
  static TextStyle boldTextFieldStyle() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  // headings
  static TextStyle HeadlineTextFieldStyle() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
  }

  // light widget
  static TextStyle LightTextFieldStyle() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black38,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    );
  }

  // semi-bold
  static TextStyle semiTextFieldStyle() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
  }

  // rupees box black
  static TextStyle boxBlack() {
    return TextStyle(
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
  }
}
