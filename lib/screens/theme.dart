import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyhClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      primaryColor: primaryClr,
      brightness: Brightness.light,
      backgroundColor: Colors.white);
  static final dark = ThemeData(
      primaryColor: darkGreyhClr,
      brightness: Brightness.dark,
      backgroundColor: darkGreyhClr);
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    
  );
}
