import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class BillwiseScreens extends StatefulWidget {
  @override
  _BillwiseScreensState createState() => _BillwiseScreensState();
}

class _BillwiseScreensState extends State<BillwiseScreens> {
  TextEditingController searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  int totalBills = 0;
  double totalSales = 0.0;
  bool isvisibile = false;

  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now(); // current date
    _fromDate = DateTime.now(); // current date
  }

  Stream<QuerySnapshot> getSalesDataStream() {
    if (_fromDate == null || _toDate == null) {
      return Stream
          .empty(); // Return an empty stream if no date range is selected
    }

    // Convert selected dates to string format 'dd/MM/yyyy'
    String fromDateString = DateFormat('dd/MM/yyyy').format(_fromDate!);
    String toDateString = DateFormat('dd/MM/yyyy').format(_toDate!);

    print('From Date String: $fromDateString'); // Debugging: check from date
    print('To Date String: $toDateString'); // Debugging: check to date

    return FirebaseFirestore.instance
        .collection('SALES_MASTER')
        .where("EMAILID_COMPANY",
            isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where("DATE", isGreaterThanOrEqualTo: fromDateString)
        .where("DATE", isLessThanOrEqualTo: toDateString)
        .orderBy('BILLNO')
        .snapshots(); // Return the QuerySnapshot stream
  }

  Future<void> _selectFromDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
      });
    }
  }

  Future<void> _selectToDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _toDate) {
      setState(() {
        _toDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isvisibile = !isvisibile;
              });
            },
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              //_printBilldata();
            },
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'BILL REPORT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonBottomnavigation(),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            if (isvisibile)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: _selectFromDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: _fromDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_fromDate!)
                                  : 'From',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: _selectToDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: _toDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_toDate!)
                                  : 'To-Date',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Card(
              elevation: 5,
              color: Colors.white,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('No Of Bills: $totalBills'),
                    Text('Total Sales:  $totalSales'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getSalesDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Nodataimage.png',

                            fit: BoxFit
                                .cover, // Adjust the path based on your project structure
                          ),
                          const Text(
                              'No Data available for selected date range'),
                        ],
                      ),
                    );
                  }

                  // Initialize the map for grouped sales data
                  Map<String, Map<String, dynamic>> groupedSalesData = {};

                  final salesData = snapshot.data!.docs;
                  for (var doc in salesData) {
                    String billNo = doc['BILLNO'].toString();
                    var quantity = doc['QTY'] ?? 0.0;
                    var totalPrice = doc['TOTAL_PRICE'] ?? 0.0;
                    var sellRate = doc['SELL_RATE'] ?? 0.0;
                    var gst = doc['GST'] ?? 0.0;
                    var itemNameEng = doc['ITEMNAME_ENG'] ?? '';
                    var itemNameTam = doc['ITEMNAME_TAM'] ?? '';
                    var userName = doc['USERNAME'] ?? '';
                    var date = doc['DATE'] ?? '';

                    // Check if the bill number already exists in groupedSalesData
                    if (groupedSalesData.containsKey(billNo)) {
                      // Aggregate the quantity and total price
                      groupedSalesData[billNo]!['QUANTITY'] += quantity;
                      groupedSalesData[billNo]!['TOTAL_PRICE'] += totalPrice;
                    } else {
                      // Add the data for the new billNo
                      groupedSalesData[billNo] = {
                        'BILLNO': billNo,
                        'QUANTITY': quantity,
                        'TOTAL_PRICE': totalPrice,
                        'SELL_RATE': sellRate,
                        'GST': gst,
                        'ITEMNAME_ENG': itemNameEng,
                        'ITEMNAME_TAM': itemNameTam,
                        'USERNAME': userName,
                        'DATE': date,
                      };
                    }
                  }

                  commonUtils.log.i('Grouped Sales Data: $groupedSalesData');

                  // Ensure that the data is not empty and is grouped correctly
                  if (groupedSalesData.isEmpty) {
                    return Center(child: Text('No grouped data available.'));
                  }
                  // totalBills = groupedSalesData.length;
                  // totalSales = groupedSalesData.values
                  //     .fold(0.0, (sum, sale) => sum + sale['TOTAL_PRICE']);
                  // Initialize variables for calculating totals
                  int billsCount = 0;
                  double salesTotal = 0.0;

                  // Loop through each document and calculate the totals
                  for (var doc in salesData) {
                    billsCount++; // Increment bill count
                    double totalPrice = doc['TOTAL_PRICE'] ?? 0.0;
                    salesTotal += totalPrice; // Add to total sales
                  }

                  // Update state with new values

                  totalBills = billsCount;
                  totalSales = salesTotal;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                  Colors.blue.shade900),
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'BILL NO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                DataColumn(
                                    label: Text(
                                  'QTY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                DataColumn(
                                    label: Text(
                                  'TOTAL PRICE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                // DataColumn(
                                //     label: Text(
                                //   'DATE',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.white),
                                // )),
                              ],
                              rows: groupedSalesData.values.map((sale) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(sale['BILLNO'].toString())),
                                    DataCell(Text(sale['QUANTITY'].toString())),
                                    DataCell(
                                        Text(sale['TOTAL_PRICE'].toString())),
                                    // DataCell(Text(sale['DATE'].toString())),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _printBilldata() async {
  try {
    final pdf = pw.Document();

    // Load the custom font from assets
    final ByteData fontData =
        await rootBundle.load('assets/Fonts/TiroTamil-Regular.ttf');
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Hello, this is a test PDF with custom font!',
              style: pw.TextStyle(
                font: font,
                fontSize: 24,
              ),
            ),
          );
        },
      ),
    );

    // Request storage permission
    // await _requestStoragePermission();

    // Get the Downloads directory on Android
    final directory = await _getDownloadDirectory();
    if (directory == null) {
      print('Download directory not available');
      return;
    }
    // Save the PDF file in the Downloads folder
    final filePath = '${directory.path}/B-BILLING.pdf';
    final file = File(filePath);
    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);

    print('PDF saved at: $filePath');
  } catch (e) {
    print('Error generating PDF: $e');
  }
}

// Request storage permission (Handles Android 10+)
Future<void> _requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    commonUtils.log.i('Storage permission granted');
  } else {
    commonUtils.log.i('Storage permission denied');
  }
}

// Get the directory for storing files
Future<Directory?> _getDownloadDirectory() async {
  // For Android 10 and above, use the appropriate directory
  if (Platform.isAndroid) {
    final directory = await getExternalStorageDirectory();
    final downloadsDirectory = Directory('${directory?.path}/Download');
    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }
    return downloadsDirectory;
  }
  // For iOS, or other platforms, you can use getApplicationDocumentsDirectory or similar
  return null;
}
