import 'package:bneedsbillappnew/Authentication/User_models.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> SaveuserRecord(UserModel user) async {
    try {
      await _db.collection('COMPANY_REGISTER').doc(user.id).set(user.toJson());
      commonUtils.log.i('Saving user record: ${user.toJson()}');
    } on FirebaseAuthException catch (e) {
      commonUtils.log.e(e.code);
    } catch (e) {
      commonUtils.log.e('Error saving user: $e');
    }
  }
}
