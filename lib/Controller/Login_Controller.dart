import 'package:bneedsbillappnew/Authentication/Repository.dart';
import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Screens/SIgnup_Screens.dart';
import 'package:bneedsbillappnew/Screens/User_Login_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final hidepasssword = true.obs;
  final isLoading = false.obs;
  final Emailid = TextEditingController();
  final Password = TextEditingController();
  GlobalKey<FormState> loginformkey = GlobalKey<FormState>();

  Future<void> login() async {
    if (loginformkey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final userCredential = await Repository.instance
            .loginwithemailandpassword(
                Emailid.text.trim(), Password.text.trim());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Get.offAll(() => UserLoginScreens());
      } catch (e) {
        // Snackbar will already show from Repository
      } finally {
        isLoading.value = false;
      }
    }
  }
}
