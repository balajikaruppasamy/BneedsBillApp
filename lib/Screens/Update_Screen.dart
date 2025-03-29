import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserScreen extends StatelessWidget {
  final TextEditingController catorgory = TextEditingController();
  final TextEditingController tam_catorgory = TextEditingController();
  String documentId = '';
  @override
  void onInit() {}

  Future<void> updateUser(
      String documentId, String catogory, String tam_cat) async {
    try {
      await FirebaseFirestore.instance
          .collection('CATEGORY_MASTER')
          .doc(documentId)
          .update({"CATEGORY": catogory, "TAMIL_CATEGORY": tam_cat});
      commonUtils.log.i("User updated successfully");
    } catch (e) {
      commonUtils.log.e("Error updating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: catorgory,
              decoration: InputDecoration(labelText: "Catogory"),
            ),
            TextField(
              controller: tam_catorgory,
              decoration: InputDecoration(labelText: "Tam_Catogory"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String cat = catorgory.text;
                String t_cat = tam_catorgory.text;
                updateUser(documentId, cat, t_cat);
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
