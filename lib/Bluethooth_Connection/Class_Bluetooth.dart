import 'package:bneedsbillappnew/Bluethooth_Connection/Bluethooth.dart';
import 'package:bneedsbillappnew/Screens/Salesentry_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothConnection {
  final List<Map<String, dynamic>> items;

  BluetoothConnection({required this.items});
  String _msj = "";
  bool connected = false;
  final PrintBluetoothThermal _printer = PrintBluetoothThermal();
  List<String> connectedDevicesMac = [];

  String connectedDeviceMac = ""; // To track the connected device

  bool _progress = false;
  String companyName = '';
  String companyAddress = '';
  String companyCity = '';
  String companyPhone = '';
  String Footername = '';
  String gstin = '';
  String streetname = '';
  int? BillNo;

  Future<void> printInvoice(BuildContext context) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('COMPANY_REGISTER')
        .where('EMAILID', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    if (userDoc.docs.isNotEmpty) {
      final userData = userDoc.docs.first.data();
      companyName = userData['COMPANYNAME'] ?? 'N/A';
      companyAddress = userData['ADDRESS'] ?? 'N/A';
      companyCity = userData['CITY'] ?? 'N/A';
      companyPhone = userData['PHONENUMBER'] ?? 'N/A';
      Footername = userData['FOOTERNMAE'] ?? ' ';
      gstin = userData['GST'] ?? 'N/A';
      streetname = userData['STREETNAME'] ?? 'N/A';
    } else {
      Fluttertoast.showToast(msg: 'No user found for this email!');
    }

    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;

    if (connectionStatus) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SalesentryScreens()), // Navigate to Sales Entry Page
      );

      String COMPANYNAME = "$companyName";
      String COMPANYADDRESS = companyAddress.isNotEmpty
          ? "\x1b\x45\x01${companyAddress},${companyCity}\x1b\x45\x00"
          : '';
      String STREETNAME =
          streetname.isNotEmpty ? "\x1b\x45\x01${streetname}\x1b\x45\x00" : '';
      String PHONE = companyPhone.isNotEmpty
          ? "\x1b\x45\x01${companyPhone}\x1b\x45\x00"
          : '';

      commonUtils.log.i("Name${companyName}, Add${COMPANYADDRESS}, ${PHONE}");

      String gst = "GSTIN : ${gstin}";

      COMPANYNAME = "\x1b\x21\x20\x1b\x45\x01" +
          " " * ((22 - (COMPANYNAME.length)) ~/ 2) +
          COMPANYNAME +
          "\x1b\x21\x20\x1b\x45\x00";
      STREETNAME = STREETNAME.isNotEmpty
          ? " " * ((50 - STREETNAME.length) ~/ 2) + STREETNAME
          : '';
      COMPANYADDRESS = COMPANYADDRESS.isNotEmpty
          ? " " * ((50 - COMPANYADDRESS.length) ~/ 2) + COMPANYADDRESS
          : '';
      PHONE = PHONE.isNotEmpty ? " " * ((50 - PHONE.length) ~/ 2) + PHONE : '';
      gst = " " * ((50 - gst.length) ~/ 2) + gst;

      List<Map<String, dynamic>> items = CommonPrintVariables.SalesData;
      String billNumber =
          items.isNotEmpty ? items[0]['BILLNO']?.toString() ?? 'N/A' : 'N/A';
      String Time = DateFormat('hh:mm a').format(DateTime.now());
      String Date = DateFormat('dd/MM/yyyy').format(DateTime.now());

      String subtotal = "0.00";
      String total = "0.00";

      // Define fixed padding for 80mm paper size
      int namePadding = 20;
      int qtyPadding = 6;
      int amtPadding = 10;
      int sellratepadding = 8;

      // Define the fixed width for columns
      int maxItemNameLength = 20;
      int rateColumnWidth = 8;
      int qtyColumnWidth = 6;
      int amtColumnWidth = 10;
      String DATETIME = "${Date}-(${Time})";

      List<String> invoice = [
        COMPANYNAME,
        STREETNAME,
        COMPANYADDRESS,
        PHONE,
        gst,
        "-" * 48,
        "BILLNO : ${billNumber.padRight(16)}" + DATETIME,
        "-" * 48,
        "ITEM".padRight(namePadding) +
            "RATE".padLeft(sellratepadding) +
            "QTY".padLeft(qtyPadding) +
            "AMT".padLeft(amtPadding),
        "-" * 48,
      ];

      // Add each item from sales data
      double totalAmount = 0.0;
      for (var item in items) {
        String itemName = item['ITEMNAME_ENG'] ?? 'N/A';

        // Handle long item names by breaking them into multiple lines
        List<String> itemNameLines = [];
        while (itemName.length > maxItemNameLength) {
          itemNameLines.add(itemName.substring(0, maxItemNameLength));
          itemName = itemName.substring(maxItemNameLength);
        }
        if (itemName.isNotEmpty) {
          itemNameLines.add(itemName);
        }

        // Parse SELL_RATE as a double, and handle if it's not a valid number
        double sellRate = double.tryParse(item['SELL_RATE'].toString()) ?? 0.0;

        // Parse QTY as an int, and handle if it's not a valid number
        int qty = int.tryParse(item['QTY'].toString()) ?? 0;

        // Calculate amount
        double amount = sellRate * qty;

        totalAmount += amount;

        // Print the first line (item name, rate, qty, amount)
        String firstLine = "${itemNameLines[0].padRight(maxItemNameLength)}" +
            sellRate.toStringAsFixed(2).padLeft(rateColumnWidth) +
            qty.toString().padLeft(qtyColumnWidth) +
            amount.toStringAsFixed(2).padLeft(amtColumnWidth);
        invoice.add(firstLine);

        // Now, print the remaining item name lines (without rate, qty, amt)
        for (int i = 1; i < itemNameLines.length; i++) {
          String itemLine = itemNameLines[i].padRight(maxItemNameLength);
          invoice.add(itemLine);
        }
      }

      subtotal = totalAmount.toStringAsFixed(2);
      total = subtotal; // Assuming no discount for simplicity
      String TOTAL = "TOTAL: ${total}";
      TOTAL = "\x1b\x21\x20\x1b\x45\x01" +
          " " * ((22 - (TOTAL.length)) ~/ 2) +
          TOTAL +
          "\x1b\x21\x20\x1b\x45\x00";

      // Add totals to the invoice
      Footername = " " * ((50 - Footername.length) ~/ 2) + Footername;

      invoice.add("-" * 48);
      invoice.add(TOTAL);
      invoice.add("-" * 48);
      invoice.add(Footername); // Add "Thank you" message as the footer
      invoice.add("");
      invoice.add("");
      invoice.add("");

      // Print each line of the invoice
      for (String line in invoice) {
        await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: "$line\n"),
        );
      }

      // Trigger a full cut after all content has been printed
      List<int> fullCutCommand = [0x1D, 0x56, 0x00]; // Full cut command
      await PrintBluetoothThermal.writeBytes(fullCutCommand);

      Fluttertoast.showToast(msg: "Invoice printed successfully.");
    } else {
      print("Printer not connected.");
    }
  }
}
