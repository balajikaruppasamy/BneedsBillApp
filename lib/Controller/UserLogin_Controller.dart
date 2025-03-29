import 'package:bneedsbillappnew/Authentication/Repository.dart';
import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserloginController extends GetxController {
  static UserloginController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs;
  final Usernmaelogin = TextEditingController();
  final Userpasswordlogin = TextEditingController();
  final GlobalKey<FormState> userLoginKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchItems(Usernmaelogin.text.toString(), Userpasswordlogin.text.trim());
  }

  void fetchItems(String name, String password) async {
    if (userLoginKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final querySnapshot = await _firestore
            .collection('USER_DETAIL')
            .where('USERNAME', isEqualTo: name.trim().toUpperCase())
            .where('USERPASSWORD', isEqualTo: password.trim().toUpperCase())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isUserLogin', true);

          Get.offAll(() => CommonBottomnavigation());

          commonUtils.log.i("Login successful!");
        } else {
          snacbar.warningsnackbar(
              tittle:
                  'Username or password is Incorrect'); // Display error message
          commonUtils.log.e("Name or Password is incorrect");
          // Fluttertoast.showToast(msg: "Name or Password is incorrect");
        }
      } catch (e) {
        commonUtils.log.e("Error fetching items: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
