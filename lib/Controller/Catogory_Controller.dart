// import 'package:bneedsbillappnew/Utility/Logger.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CatogoryController extends GetxController {
//   CatogoryController get instance => Get.find();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
//   GlobalKey<FormState> Catogorykey = GlobalKey<FormState>();
//   final englishCatogory = TextEditingController();
//   final tamilCatogory = TextEditingController();
//   String DOCITD = ' ';
//   @override
//   void onInit() {
//     super.onInit();
//     Fecthcategoryitem();
//   }
//
//   Future<void> Fecthcategoryitem() async {
//     try {
//       _firestore
//           .collection('CATEGORY_MASTER')
//           .where('EMAILID_COMPANY',
//               isEqualTo: FirebaseAuth.instance.currentUser?.email)
//           .snapshots()
//           .listen((snapshot) {
//         categories.value = snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//       });
//       print('Categories: $categories');
//     } catch (e) {
//       commonUtils.log.e(e);
//     }
//   }
//
//   // Future<void> Addcategoryitem() async {
//   //   try {
//   //     final SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
//   //     commonUtils.log.i('LUsernmae  == $LUsernmae');
//   //
//   //     if (Catogorykey.currentState != null &&
//   //         Catogorykey.currentState!.validate()) {
//   //       final userEmail = FirebaseAuth.instance.currentUser?.email;
//   //       if (userEmail == null) {
//   //         commonUtils.log.e('User is not authenticated');
//   //         return;
//   //       }
//   //       await _firestore.collection('CATEGORY_MASTER').add({
//   //         'EMAILID_COMPANY': userEmail,
//   //         'USERNAME': LUsernmae,
//   //         'CATEGORY': englishCatogory.text.trim().toUpperCase(),
//   //         'TAMIL_CATEGORY': tamilCatogory.text.trim().toUpperCase(),
//   //       });
//   //       clearFields();
//   //       commonUtils.log.i('Added Successfully');
//   //     } else {
//   //       commonUtils.log.e('Form validation failed');
//   //     }
//   //   } catch (e) {
//   //     commonUtils.log.e('Error: $e');
//   //   }
//   // }
//   Future<void> Addcategoryitem({String? docId}) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
//       commonUtils.log.i('LUsernmae == $LUsernmae');
//
//       if (Catogorykey.currentState != null &&
//           Catogorykey.currentState!.validate()) {
//         final userEmail = FirebaseAuth.instance.currentUser?.email;
//         if (userEmail == null) {
//           commonUtils.log.e('User is not authenticated');
//           return;
//         }
//
//         final categoryData = {
//           'EMAILID_COMPANY': userEmail,
//           'USERNAME': LUsernmae,
//           'CATEGORY': englishCatogory.text.trim().toUpperCase(),
//           'TAMIL_CATEGORY': tamilCatogory.text.trim().toUpperCase(),
//         };
//
//         if (docId == null) {
//           var docRef =
//               await _firestore.collection('CATEGORY_MASTER').add(categoryData);
//           // newDocId = docRef.id;
//           // commonUtils.log
//           //     .i('Category Added Successfully with Document ID: $newDocId');
//         } else {}
//
//         clearFields();
//       } else {
//         commonUtils.log.e('Form validation failed');
//       }
//     } catch (e) {
//       commonUtils.log.e('Error: $e');
//     }
//   }
//
//   Future<void> Update(String docid) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
//       commonUtils.log.i('LUsernmae == $LUsernmae');
//       final userEmail = FirebaseAuth.instance.currentUser?.email;
//
//       await _firestore.collection('CATEGORY_MASTER').doc(docid).update({
//         'EMAILID_COMPANY': userEmail,
//         'USERNAME': LUsernmae,
//         'CATEGORY': englishCatogory.text.trim().toUpperCase(),
//         'TAMIL_CATEGORY': tamilCatogory.text.trim().toUpperCase(),
//       });
//       commonUtils.log
//           .i('Category Updated Successfully with Document ID: $DOCITD');
//     } catch (e) {
//       commonUtils.log.e(e);
//     }
//   }
//
//   void clearFields() {
//     englishCatogory.clear();
//     tamilCatogory.clear();
//   }
// }
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatogoryController extends GetxController {
  String? selectedDocId;

  CatogoryController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  GlobalKey<FormState> Catogorykey = GlobalKey<FormState>();
  final englishCatogory = TextEditingController();
  final tamilCatogory = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Fecthcategoryitem();
  }
/*
  Future<void> fetchCategoryItems() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        commonUtils.log.e('User is not authenticated');
        return;
      }

      _firestore
          .collection('CATEGORY_MASTER')
          .where('EMAILID_COMPANY', isEqualTo: userEmail)
          .snapshots()
          .listen((snapshot) {
        categories.value = snapshot.docs.map((doc) {
          return {
            ...doc.data(),
            'docId': doc.id, // Include document ID for edit/update operations
          };
        }).toList();
      });

      commonUtils.log.i('Categories fetched successfully.');
    } catch (e) {
      commonUtils.log.e('Error fetching categories: $e');
    }
  }*/

  Future<void> Fecthcategoryitem() async {
    try {
      _firestore
          .collection('CATEGORY_MASTER')
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots()
          .listen((snapshot) {
        categories.value = snapshot.docs
            .map((doc) =>
                {...doc.data(), 'docId': doc.id} as Map<String, dynamic>)
            .toList();
      });
      print('Categories: $categories');
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  Future<void> addOrUpdateCategory({String? docId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
      commonUtils.log.i('LUsernmae == $LUsernmae');

      if (Catogorykey.currentState != null &&
          Catogorykey.currentState!.validate()) {
        final userEmail = FirebaseAuth.instance.currentUser?.email;
        if (userEmail == null) {
          commonUtils.log.e('User is not authenticated');
          return;
        }

        final categoryData = {
          'EMAILID_COMPANY': userEmail,
          'USERNAME': LUsernmae,
          'CATEGORY': englishCatogory.text.trim().toUpperCase(),
          'TAMIL_CATEGORY': tamilCatogory.text.trim().toUpperCase(),
        };

        if (docId == null) {
          await _firestore.collection('CATEGORY_MASTER').add(categoryData);
          commonUtils.log.i('Category Added Successfully');
        } else {
          await _firestore
              .collection('CATEGORY_MASTER')
              .doc(docId)
              .update(categoryData);
          commonUtils.log
              .i('Category Updated Successfully with Document ID: $docId');
        }

        clearFields();
      } else {
        commonUtils.log.e('Form validation failed');
      }
    } catch (e) {
      commonUtils.log.e('Error: $e');
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      await _firestore.collection('CATEGORY_MASTER').doc(docId).delete();
      // Fetch the updated list of categories after deletion
      await Fecthcategoryitem();
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category');
    }
  }

/*  Future<void> addOrUpdateCategory({String? docId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('PREFSUSERNAME') ?? '';
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        commonUtils.log.e('User is not authenticated');
        return;
      }

      if (Catogorykey.currentState == null ||
          !Catogorykey.currentState!.validate()) {
        commonUtils.log.e('Form validation failed');
        return;
      }

      final categoryData = {
        'EMAILID_COMPANY': userEmail,
        'USERNAME': userName,
        'CATEGORY': englishCatogory.text.trim().toUpperCase(),
        'TAMIL_CATEGORY': tamilCatogory.text.trim().toUpperCase(),
      };

      if (selectedDocId == null) {
        // Add new category
        final docRef =
            await _firestore.collection('CATEGORY_MASTER').add(categoryData);
        commonUtils.log
            .i('Category added successfully with Document ID: ${docRef.id}');
      } else {
        // Update existing category
        await _firestore
            .collection('CATEGORY_MASTER')
            .doc(docId)
            .update(categoryData);
        commonUtils.log
            .i('Category updated successfully with Document ID: $docId');

      }

      clearFields();
      Fecthcategoryitem();
      // selectedDocId = null; // Reset after operation
    } catch (e) {
      commonUtils.log.e('Error adding/updating category: $e');
    }
  }*/

  void setCategoryForEdit(Map<String, dynamic> category) {
    selectedDocId = category['docId'];
    englishCatogory.text = category['CATEGORY'] ?? '';
    tamilCatogory.text = category['TAMIL_CATEGORY'] ?? '';
  }

  void clearFields() {
    englishCatogory.clear();
    tamilCatogory.clear();
    // selectedDocId = null; // Clear selectedDocId for new entries
  }
}
