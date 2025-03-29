import 'package:bneedsbillappnew/Authentication/Repository.dart';
import 'package:bneedsbillappnew/Authentication/User_Repository.dart';
import 'package:bneedsbillappnew/Authentication/User_models.dart';
import 'package:bneedsbillappnew/Screens/Login_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  SignupController();

  final companyid = TextEditingController();
  final Companyname = TextEditingController();
  final Address = TextEditingController();
  final City = TextEditingController();
  final Emailid = TextEditingController();
  final Phonenumber = TextEditingController();
  final passwords = TextEditingController();
  final Streetname = TextEditingController();
  final gst = TextEditingController();
  final Footernmae = TextEditingController();
  String companyname = '';
  String address = '';
  var isLoading = false.obs;
  var companyDetails = {}.obs; // Stores the fetched company details
  GlobalKey<FormState> signupFormkey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    _fetchCompanyNameFromFirestore();
  }

  Future<void> Signup() async {
    try {
      if (!Get.isRegistered<Repository>()) {
        Get.lazyPut(() => Repository());
      }
      final repository = Repository.instance;
      final usercredential = await repository.registerWithEmailAndPassword(
        Emailid.text.trim(),
        passwords.text.trim(),
      );

      final NewUser = UserModel(
          id: usercredential.user!.uid,
          Companyid: companyid.text.trim().toUpperCase(),
          Companyname: Companyname.text.trim().toUpperCase(),
          Address: Address.text.trim().toUpperCase(),
          City: City.text.trim().toUpperCase(),
          Emailid: Emailid.text.trim(),
          passwords: passwords.text.trim(),
          Phonenumber: Phonenumber.text.trim(),
          Streetname: Streetname.text.trim().toUpperCase(),
          Active: 'N',
          gst: gst.text.trim().toUpperCase());

      final userRepositorys = Get.put(UserRepository());
      await userRepositorys.SaveuserRecord(NewUser);
      commonUtils.log.i(NewUser);
      Fluttertoast.showToast(msg: 'Signed Successfully!');
      Get.to(LoginScreens());
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  Future<void> _fetchCompanyNameFromFirestore() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('COMPANY_REGISTER')
          .where('EMAILID', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();

        Companyname.text = userData['COMPANYNAME'] ?? 'N/A';
        Address.text = userData['ADDRESS'] ?? 'N/A';
        City.text = userData['CITY'] ?? 'N/A';
        Phonenumber.text = userData['PHONENUMBER'] ?? 'N/A';
        Emailid.text = userData['EMAILID'] ?? 'N/A';
        Address.text = userData['ADDRESS'] ?? 'N/A';
        City.text = userData['CITY'] ?? 'N/A';
        Footernmae.text = userData['FOOTERNMAE'] ?? 'N/A';
        gst.text = userData['GST'] ?? 'N/A';
        Streetname.text = userData['STREETNAME'] ?? 'N/A';
      } else {
        Fluttertoast.showToast(msg: 'No user found for this email!');
      }
    } catch (e) {
      commonUtils.log.e("Error fetching company name: $e");
      // Fluttertoast.showToast(msg: 'Failed to fetch company name.');
    }
  }

  Future<void> updateCompanyDetails() async {
    isLoading.value = true;
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('COMPANY_REGISTER')
          .where('EMAILID', isEqualTo: Emailid.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('COMPANY_REGISTER')
            .doc(docId)
            .update({
          'COMPANYNAME': Companyname.text.toUpperCase(),
          'ADDRESS': Address.text.toUpperCase(),
          'CITY': City.text.toUpperCase(),
          'PHONENUMBER': Phonenumber.text.toUpperCase(),
          'EMAILID': Emailid.text,
          'STREETNAME': Streetname.text.toUpperCase(),
          'GST': gst.text.toUpperCase(),
          'FOOTERNMAE': Footernmae.text.toUpperCase(),
        });

        Fluttertoast.showToast(msg: ' updated successfully.');
      } else {
        Fluttertoast.showToast(msg: 'Company not found.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update company details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
