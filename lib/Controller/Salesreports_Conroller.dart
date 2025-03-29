import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SalesreportsConroller extends GetxController {
  static SalesreportsConroller get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables to store total bills, total amount, and grouped sales data
  RxInt todayTotalBills = 0.obs;
  RxDouble todayTotalAmount = 0.0.obs;
  RxMap<String, double> groupedSalesData = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaySalesData();
    commonUtils.log.i("fetchTodaySalesData called");
  }

  // Method to fetch today's sales data
  void fetchTodaySalesData() async {
    try {
      DateTime today = DateTime.now();
      String formattedDate =
          "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";

      // Listen for real-time updates from Firestore
      _firestore
          .collection('SALES_MASTER')
          .where('DATE', isEqualTo: formattedDate)
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots()
          .listen((querySnapshot) {
        // Initialize a map to group data by BILLNO and store total amount for each bill
        Map<String, double> tempGroupedSalesData = {};

        // Process each document in the snapshot
        for (var doc in querySnapshot.docs) {
          String billNo = doc['BILLNO'].toString();
          var totalPrice = doc['TOTAL_PRICE'] ?? 0.0;

          // Check if the bill number already exists in the grouped map
          if (tempGroupedSalesData.containsKey(billNo)) {
            // If the bill number exists, add the total price for this bill
            tempGroupedSalesData[billNo] =
                tempGroupedSalesData[billNo]! + totalPrice;
          } else {
            // If the bill number doesn't exist, add a new entry with the total price
            tempGroupedSalesData[billNo] = totalPrice;
          }
        }

        // After processing all documents, update the RxMap with grouped sales data
        groupedSalesData.value = tempGroupedSalesData;

        // Calculate total bills and total amount
        todayTotalBills.value = groupedSalesData.length;
        todayTotalAmount.value =
            groupedSalesData.values.fold(0.0, (sum, amount) {
          return sum + amount;
        });

        // Log the total bills and amount
        print("Total Bills: ${todayTotalBills.value}");
        print("Total Amount: ${todayTotalAmount.value}");
      });
    } catch (e) {
      print('Error fetching today\'s sales data: $e');
      // Optionally show an error message to the user
      commonUtils.log.e("Error fetching today's sales data: $e");
    }
  }
}
