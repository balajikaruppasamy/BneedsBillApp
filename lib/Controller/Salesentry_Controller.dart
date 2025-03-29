import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesentryController extends GetxController {
  static SalesentryController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<String> categories = <String>[].obs; // For category dropdown
  RxList<Map<String, dynamic>> allItems =
      <Map<String, dynamic>>[].obs; // All items
  RxList<Map<String, dynamic>> filteredItems =
      <Map<String, dynamic>>[].obs; // Items filtered by category
  RxList<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[].obs;
  var selectedCategory = "".obs; // Current selected category
  var billNumber = 0.obs; // Bill number as Rx
  final resetbillno = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchItems();
    fetchCurrentBillNumber(); // Fetch the current bill number when the app initializes
  }

  Future<void> AddItementry() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
      commonUtils.log.i('LUsernmae  == $LUsernmae');

      final Companyemail = FirebaseAuth.instance.currentUser?.email;
      if (Companyemail == null) {
        commonUtils.log.e('User is not authenticated');
        return;
      }
      await _firestore.collection('SALES_MASTER').add({
        'EMAILID_COMPANY': Companyemail,
        'USERNAME': LUsernmae,
        'CATEGORY': selectedCategory.value,
      });

      commonUtils.log.i('Add Item Successfully');
    } catch (e) {
      commonUtils.log.e(e);
    }
  }

  Future<void> fetchCategories() async {
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        commonUtils.log.e("User not authenticated");
        return;
      }

      _firestore
          .collection('CATEGORY_MASTER')
          .where('EMAILID_COMPANY', isEqualTo: email)
          .snapshots()
          .listen((querySnapshot) {
        categories.value = querySnapshot.docs
            .map((doc) => doc['CATEGORY'].toString())
            .toList();
        commonUtils.log.i('Categories updated: ${categories.value}');
      });
    } catch (e) {
      commonUtils.log.e("Error fetching categories: $e");
    }
  }

  /*Future<void> fetchCategories() async {
    try {
      _firestore
          .collection('CATEGORY_MASTER')
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots() // Listen for real-time updates
          .listen((querySnapshot) {
        categories.value = querySnapshot.docs
            .map((doc) => doc['CATEGORY'].toString())
            .toList();
        print('Categories updated: ${categories.value}');
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }*/

  // Fetch all items
  void fetchItems() {
    _firestore
        .collection('ITEM_MASTER')
        .where('EMAILID_COMPANY',
            isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .snapshots()
        .listen((querySnapshot) {
      allItems.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (selectedCategory.isNotEmpty) {
        filterItemsByCategory(selectedCategory.value);
      }
    });
  }

  // Filter items by category
  void filterItemsByCategory(String category) {
    selectedCategory.value = category;

    filteredItems.value =
        allItems.where((item) => item['CATEGORY'] == category).toList();
    filteredItems.refresh();
  }

  void addItem(Map<String, dynamic> item) {
    // Check if the item already exists in the selectedItems list
    int existingIndex = selectedItems.indexWhere(
        (element) => element['ITEMNAME_ENG'] == item['ITEMNAME_ENG']);

    if (existingIndex != -1) {
      // If the item exists, increment its quantity
      selectedItems[existingIndex]['quantity'] += 1;
    } else {
      // If the item does not exist, add it with an initial quantity of 1
      var newItem = Map<String, dynamic>.from(item);
      newItem['quantity'] = 1;
      selectedItems.add(newItem);
    }

    selectedItems.refresh();
  }
  void updateQuantityWithValue(int index, int quantity) {
    if (index >= 0 && index < selectedItems.length) {
      selectedItems[index]['quantity'] = quantity.toString();
      selectedItems.refresh();  // Trigger UI update
    }
  }

  void updateQuantity(int index, bool increment) {
    final currentItem = selectedItems[index];

    // Get the current quantity
    int quantity = int.tryParse(currentItem['quantity'].toString()) ?? 0;

    if (increment) {
      // Increment quantity
      quantity += 1;
    } else {
      // Decrement quantity
      if (quantity > 0) {
        quantity -= 1;
      }
      // Remove item if quantity becomes zero
      if (quantity == 0) {
        selectedItems.removeAt(index);
        selectedItems.refresh();
        return;
      }
    }

    // Update the item with the new quantity
    selectedItems[index]['quantity'] = quantity;

    // Trigger UI update
    selectedItems.refresh();
  }

  Future<void> fetchCurrentBillNumber() async {
    try {
      final doc = await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();

      if (doc.exists) {
        // If the user exists, fetch the last bill number
        billNumber.value = doc['billNumber'];
      } else {
        // If it's a new user, initialize the bill number to 1
        billNumber.value = 1;
        await _firestore
            .collection('bill_counter')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .set({'billNumber': billNumber.value});
      }
    } catch (e) {
      print("Error fetching current bill number: $e");
    }
  }

// Increment the bill number and save it back to Firestore
  Future<void> incrementBillNumber() async {
    try {
      billNumber.value++; // Increment the bill number
      await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({'billNumber': billNumber.value});
      print('Bill number incremented: ${billNumber.value}');
    } catch (e) {
      print("Error incrementing bill number: $e");
    }
  }

// Function to create a new bill
  Future<void> createNewBill() async {
    // Call this method when a new bill is created
    await incrementBillNumber(); // Increment the bill number first

    String currentBillNumber = "BILL-${billNumber.value}"; // Format as needed
    print("Creating bill with number: $currentBillNumber");

    // Now, use `currentBillNumber` to create the bill in your database or UI
  }

// Function to reset the bill number to a specific value
  Future<void> restBillNumber(int newBillNumber) async {
    try {
      // Set the bill number to the new value
      billNumber.value = newBillNumber;
      await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({'billNumber': billNumber.value});

      // Log the success message
      print('Bill number reset to: ${billNumber.value}');
    } catch (e) {
      // Handle any errors that occur during the update process
      print("Error resetting bill number: $e");
    }
  }

/*  Future<void> fetchCurrentBillNumber() async {
    try {
      final doc = await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth
              .instance.currentUser?.email) // Using email as document ID
          .get();

      if (doc.exists) {
        // If the user exists, fetch the last bill number
        billNumber.value = doc['billNumber'];
      } else {
        // If it's a new user, initialize the bill number to 1
        billNumber.value = 1;
        _firestore
            .collection('bill_counter')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .set({
          'billNumber': billNumber.value,
        });
      }
    } catch (e) {
      print("Error fetching current bill number: $e");
    }
  }

  // Increment the bill number and save it back to Firestore
  Future<void> incrementBillNumber() async {
    try {
      billNumber.value++; // Increment the bill number
      await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({
        'billNumber': billNumber.value,
      });
      print('Bill number incremented: ${billNumber.value}');
    } catch (e) {
      print("Error incrementing bill number: $e");
    }
  }

  // Function to create a new bill
  Future<void> createNewBill() async {
    // Call this method when a new bill is created
    await incrementBillNumber(); // Increment the bill number first

    String currentBillNumber =
        "BILL-${billNumber.value}"; // You can format it as needed
    print("Creating bill with number: $currentBillNumber");

    // Now, use `currentBillNumber` to create the bill in your database or UI
  }

  Future<void> restBillNumber() async {
    try {
      // Update the Firestore document with the incremented bill number
      await _firestore
          .collection('bill_counter')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({
        'billNumber': resetbillno.text,
      });

      // Log the success message
      commonUtils.log.i(
          'Bill number incremented and updated in Firestore: ${billNumber.value}');
    } catch (e) {
      // Handle any errors that occur during the update process
      commonUtils.log.i("Error incrementing or updating bill number: $e");
    }
  }*/

/*  void updateQuantity(int index, bool increment) {
    final currentItem = selectedItems[index];

    // Get the current quantity
    int quantity = int.tryParse(currentItem['quantity'].toString()) ?? 0;

    // Increment quantity if `true`
    if (increment) {
      quantity += 1;
    }

    // Update the item with the new quantity
    selectedItems[index]['quantity'] = quantity;

    // Trigger UI update
    selectedItems.refresh();
  }*/
}
