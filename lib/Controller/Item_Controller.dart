import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController extends GetxController {
  static ItemController get instance => Get.find();
  ItemController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> Itemcontrollerkey = GlobalKey<FormState>();

  RxList<Map<String, dynamic>> Itemmamster = <Map<String, dynamic>>[].obs;
  final Itemname_eng = TextEditingController();
  final Itemname_tam = TextEditingController();
  final mrp = TextEditingController();
  final Pur_rate = TextEditingController();
  final Sell_rate = TextEditingController();
  final gst = TextEditingController();
  var selectedCategory = "".obs;

  final dropdownItems = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    Fecthdropdowncatogoryitem();
    Fecthitemmaster();
  }

  // Future<void> Fecthdropdowncatogoryitem() async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection('CATEGORY_MASTER')
  //         .where('EMAILID_COMPANY',
  //             isEqualTo: FirebaseAuth.instance.currentUser?.email)
  //         .get();
  //
  //     dropdownItems.value =
  //         querySnapshot.docs.map((doc) => doc['CATEGORY'].toString()).toList();
  //   } catch (e) {
  //     commonUtils.log.e(e);
  //   }
  // }
  Future<void> Fecthdropdowncatogoryitem() async {
    try {
      _firestore
          .collection('CATEGORY_MASTER')
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots() // Listen for real-time changes
          .listen((querySnapshot) {
        dropdownItems.value = querySnapshot.docs
            .map((doc) => doc['CATEGORY'].toString())
            .toList();
        commonUtils.log.i('Category items updated: ${dropdownItems.value}');
      });
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  Future<void> Fecthitemmaster() async {
    try {
      _firestore
          .collection('ITEM_MASTER')
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots()
          .listen((snapshot) {
        Itemmamster.value = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
      print('ITEM_MASTER: $Itemmamster');
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  Future<void> AddItementry() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
      commonUtils.log.i('LUsernmae  == $LUsernmae');
      if (Itemcontrollerkey.currentState != null &&
          Itemcontrollerkey.currentState!.validate()) {
        final Companyemail = FirebaseAuth.instance.currentUser?.email;
        if (Companyemail == null) {
          commonUtils.log.e('User is not authenticated');
          return;
        }
        await _firestore.collection('ITEM_MASTER').add({
          'EMAILID_COMPANY': Companyemail,
          'USERNAME': LUsernmae,
          'CATEGORY': selectedCategory.value,
          'ITEMNAME_ENG': Itemname_eng.text.trim().toUpperCase(),
          'ITEMNAME_TAMIL': Itemname_tam.text.trim().toUpperCase(),
          'PUR_RATE': Pur_rate.text.trim().toUpperCase(),
          'SELL_RATE': Sell_rate.text.trim().toUpperCase(),
          'MRP': mrp.text.trim().toUpperCase(),
          'GST': gst.text.trim().toUpperCase(),
        });
        clearFields();
        commonUtils.log.i('Add Item Successfully');
      }
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  void clearFields() {
    Itemname_eng.clear();
    Itemname_tam.clear();
    Pur_rate.clear();
    Sell_rate.clear();
    mrp.clear();
    gst.clear();
    selectedCategory.value = '';
  }
}
