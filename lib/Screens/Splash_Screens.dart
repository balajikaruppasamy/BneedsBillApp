import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Screens/Login_Screens.dart';
import 'package:bneedsbillappnew/Screens/User_Login_Screens.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Adding a delay to simulate a splash screen display
    await Future.delayed(const Duration(seconds: 3));

    // Retrieve login state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCompanyLogin = prefs.getBool('isLoggedIn') ?? false;
    bool isUserLogin = prefs.getBool('isUserLogin') ?? false;

    if (!isCompanyLogin) {
      Get.to(LoginScreens());
    } else if (!isUserLogin) {
      Get.to(UserLoginScreens());
    } else {
      Get.off(CommonBottomnavigation());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make the splash screen full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Blogo.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          // const Center(
          //   child: CircularProgressIndicator(
          //     valueColor:
          //         AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
          //   ),
          // ),
        ],
      ),
    );
  }
}
