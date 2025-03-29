import 'dart:ui';
import 'package:flutter/material.dart';

class C_ColorsPages {
  C_ColorsPages._();

// App Basic Color
  static const Color primarycolor = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accen = Color(0xFFb0c7ff);
// Text Color
  static const Color textprimary = Color(0xFF333333);
  static const Color textsecondary = Color(0xFF6C757D);
  static const Color textwhite = Colors.white;

  //Gradient colors
  static const Gradient linergradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c4),
      ]);

// background Color

  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color transperent = Colors.transparent;

// background Color

  static const Color light_Container = Color(0xFFF6F6F6);
  static const Color dark_Container = Color(0xFF272727);

  //Button Colors

  static const Color Button_Primary = Color(0xFF4b68ff);
  static const Color Button_Secondary = Color(0xFF6C757D);
  static const Color Button_Disabled = Color(0xFFC4C4C4);

//Border Colors
  static const Color Border_Primary = Color(0xFFD9D9D9);
  static const Color Border_secondary = Color(0xFFE6E6E6);

  //Error And Validation Colors
  static const Color Error = Color(0xFFD32F2F);
  static const Color Success = Color(0xFF388E3C);
  static const Color Waring = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  //Naturals shades
  static const Color Black = Colors.black;
  static const Color Darkestgrey = Color(0xFF4F4F4F);
  static const Color Darkgrey = Color(0xFF939393);
  static const Color grey = Colors.grey;
  static const Color softgrey = Color(0xFFF4F4F4);
  static const Color Lightgrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
