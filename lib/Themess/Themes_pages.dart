import 'package:flutter/material.dart';

import 'Appbartheme_Pages.dart';
import 'Bottomthemedata_Pages.dart';
import 'CheckBoxTheme_Pages.dart';
import 'ChipTheme_Pages.dart';
import 'Elevatedthemdata_pages.dart';
import 'Outlinebutton_Pages.dart';
import 'TextField_Pages.dart';
import 'TextTheme_pages.dart';

class T_ThemesPages {
  T_ThemesPages._();

  static ThemeData Lightheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: C_TextthemePages.lightTheme,
    chipTheme: C_Chipthem.LightchipThemeData,


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
    chipTheme: C_Chipthem.DarkchipThemeData,
    scaffoldBackgroundColor: Colors.black,

    checkboxTheme: C_CheckBoxtheme.Darkcheckbox,
    bottomSheetTheme: C_BottomthemedataPages.darkbottomSheetThemeData,
    inputDecorationTheme: C_TextfieldPages.DarkinputDecorationTheme,
    outlinedButtonTheme: C_OutlinebuttonPages.Darkoutlinebutton,
    elevatedButtonTheme: C_elevaedthemdata.darklevatedButtonThemeData,
  );
}
