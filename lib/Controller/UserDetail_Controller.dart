import 'package:bneedsbillappnew/Screens/User_Login_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserdetailController extends GetxController {
  static UserdetailController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  // Text editing controllers
  final Name = TextEditingController();
  RxString Username = ''.obs;
  final isLoading = false.obs;

  final Userpassword = TextEditingController();
  final Userphonenumber = TextEditingController();
  final GlobalKey<FormState> Userformkey = GlobalKey<FormState>();
  RxString fetchedCompanyId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchusername();
  }

  void fetchItems() async {
    try {
      final querySnapshot = await _firestore
          .collection('COMPANY_REGISTER')
          .where('EMAILID', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String companyId = querySnapshot.docs.first['COMPANYID'];
        fetchedCompanyId.value = companyId;
        print('Fetched CompanyId: $companyId');
        print('Fetched CompanyId: ${fetchedCompanyId.value}');
      } else {
        // If no match found, show an error message
        print("Name or Password is incorrect");
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  void fetchusername() async {
    try {
      final querySnapshot = await _firestore
          .collection('USER_DETAIL')
          .where('COMPANY_EMAIL',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data(); // Access the first document
        final username =
            userData['USERNAME'] ?? 'Unknown'; // Fetch the 'USERNAME' field

        // Set the fetched username to your controller or variable
        Username.value = username;
        update(); // Notify listeners if using GetX
        commonUtils.log.i('Fetched Username: ${Username.value}');
      } else {
        commonUtils.log.i('No user details found for the given email.');
      }
    } catch (e) {
      commonUtils.log.i('Failed to fetch user details: $e');
    }
  }

  void addItem() async {
    try {
      if (Userformkey.currentState!.validate()) {
        isLoading.value = true;
        await _firestore.collection('USER_DETAIL').add({
          'USERNAME': Name.text.trim().toUpperCase(),
          'COMPANY_ID': fetchedCompanyId.value,
          'USERPASSWORD': Userpassword.text.trim().toUpperCase(),
          'USERPHONENUMBER': Userphonenumber.text.trim(),
          'COMPANY_EMAIL': FirebaseAuth.instance.currentUser?.email,
        });
        clearFields();
        Get.to(UserLoginScreens());
      }
    } catch (e) {
      print("Error adding item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    Name.clear();

    Userpassword.clear();
    Userphonenumber.clear();
  }
}
