import 'package:bneedsbillappnew/Authentication/Repository.dart';

import 'package:bneedsbillappnew/Screens/Splash_Screens.dart';
import 'package:bneedsbillappnew/Themess/Themes_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(Repository());
  SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: T_ThemesPages.Lightheme,
      home: SplashScreens(),
    );
  }
}
