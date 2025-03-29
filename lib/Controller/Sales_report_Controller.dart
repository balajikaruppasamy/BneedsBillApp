import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SalesReportController extends GetxController {
  static SalesReportController get instance => Get.find();

  SalesReportController();
  var isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> Itemcontrollerkey = GlobalKey<FormState>();

  RxList<Map<String, dynamic>> salesmaster = <Map<String, dynamic>>[].obs;
  RxMap<String, List<Map<String, dynamic>>> groupedSalesData =
      <String, List<Map<String, dynamic>>>{}.obs;
  @override
  void onInit() {
    super.onInit();
    Fecthsalesreport();
  }

  Future<void> Fecthsalesreport() async {
    try {
      isLoading.value = true;
      _firestore
          .collection('SALES_MASTER')
          .where('EMAILID_COMPANY',
              isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .orderBy('BILLNO')
          .snapshots()
          .listen((snapshot) {
        // Map the required fields from the snapshot
        salesmaster.value = snapshot.docs.map((doc) {
          return {
            'BILLNO': doc['BILLNO'].toString(),
            'GST': doc['GST'].toString(),
            'ITEMNAME_ENG': doc['ITEMNAME_ENG'] ?? '',
            'ITEMNAME_TAM': doc['ITEMNAME_TAM'] ?? '',
            'SELL_RATE': doc['SELL_RATE'].toString(),
            'TOTAL_PRICE': doc['TOTAL_PRICE'].toString(),
            'USERNAME': doc['USERNAME'] ?? '',
            'QUANTITY': doc['QTY'].toString(),
          };
        }).toList();

        // Group by BILLNO
        groupedSalesData.clear();
        for (var item in salesmaster) {
          final billNo = item['BILLNO'];
          if (!groupedSalesData.containsKey(billNo)) {
            groupedSalesData[billNo] = [];
          }
          groupedSalesData[billNo]?.add(item);
        }

        commonUtils.log.i('Grouped Sales Data: ${salesmaster.value}');
        isLoading.value = false;
      });
    } catch (e) {
      commonUtils.log.e(e);
    }
  }
  // Future<void> Fecthsalesreport() async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('SALES_MASTER')
  //         .orderBy('BILLNO')  // You can order by a field (e.g., BILLNO)
  //         .limit(10)           // Limit to the first 10 documents
  //         .get()
  //         .then((querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         print(doc.data());
  //       });
  //     })
  //         .catchError((e) {
  //       print("Error: $e");
  //     });
  //
  //   } catch (e) {
  //     commonUtils.log.e(e);
  //   }
  // }
}
