import 'package:bneedsbillappnew/Themess/Appbartheme_Pages.dart';
import 'package:bneedsbillappnew/Themess/Bottomthemedata_Pages.dart';
import 'package:bneedsbillappnew/Themess/CheckBoxTheme_Pages.dart';
import 'package:bneedsbillappnew/Themess/Elevatedthemdata_pages.dart';
import 'package:bneedsbillappnew/Themess/Outlinebutton_Pages.dart';
import 'package:bneedsbillappnew/Themess/TextField_Pages.dart';
import 'package:bneedsbillappnew/Themess/TextTheme_pages.dart';
import 'package:flutter/material.dart';

class T_ThemesPages {
  T_ThemesPages._();

  static ThemeData Lightheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: C_TextthemePages.lightTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: C_AppbarthemePages.lightbartheme,
    checkboxTheme: C_CheckBoxtheme.lightcheckbox,
    bottomSheetTheme: C_BottomthemedataPages.lightbottomSheetThemeData,
    inputDecorationTheme: C_TextfieldPages.lightinputDecorationTheme,
    outlinedButtonTheme: C_OutlinebuttonPages.Lightoutlinebutton,
    elevatedButtonTheme: C_elevaedthemdata.lightelevatedButtonThemeData,
  );

  static ThemeData darktheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: C_TextthemePages.darkTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: C_AppbarthemePages.darktbartheme,
    checkboxTheme: C_CheckBoxtheme.Darkcheckbox,
    bottomSheetTheme: C_BottomthemedataPages.darkbottomSheetThemeData,
    inputDecorationTheme: C_TextfieldPages.DarkinputDecorationTheme,
    outlinedButtonTheme: C_OutlinebuttonPages.Darkoutlinebutton,
    elevatedButtonTheme: C_elevaedthemdata.darklevatedButtonThemeData,
  );
}
