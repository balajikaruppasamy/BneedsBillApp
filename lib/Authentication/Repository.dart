import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Repository extends GetxController {
  static Repository get instance => Get.find();

  final auth = FirebaseAuth.instance;

  Future<UserCredential> loginwithemailandpassword(
      String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Try again later.';
          break;
        default:
          errorMessage = ' ${e.message}';
      }
      snacbar.warningsnackbar(tittle: errorMessage); // Display error message
      throw Exception(errorMessage); // Rethrow to handle it in the controller
    } catch (e) {
      String errorMessage = 'An unexpected error occurred: $e';
      snacbar.warningsnackbar(tittle: errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use. Please try another one.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      } else if (e.code == 'weak-password') {
        errorMessage =
            'The password is too weak. Please use a stronger password.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.message}';
      }

      snacbar.warningsnackbar(tittle: errorMessage);

      throw Exception(errorMessage);
    } catch (e) {
      String errorMessage = 'An unexpected error occurred: $e';
      snacbar.warningsnackbar(tittle: errorMessage);
      throw Exception(errorMessage);
    }
  }
}

class snacbar {
  static warningsnackbar({required tittle, meesage = ''}) {
    Get.snackbar(
      tittle,
      meesage,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      icon: Icon(Icons.warning),
    );
  }
}
