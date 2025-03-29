import 'package:bneedsbillappnew/Controller/Sales_report_Controller.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SalesreportScreens extends StatefulWidget {
  @override
  _SalesreportScreensState createState() => _SalesreportScreensState();
}

class _SalesreportScreensState extends State<SalesreportScreens> {
  String startDate = ''; // You can initialize with a default value
  String endDate = ''; // You can initialize with a default value

  // Method to fetch the bill data (assuming it's defined)
  Future<List<Map<String, dynamic>>> fetchBillData() async {
    return [];
  }

  @override
  void initState() {
    super.initState();
    Get.put(SalesReportController());

    SalesReportController.instance.Fecthsalesreport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _printBilldata();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              '$startDate',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                        ),
                        Text(
                          '$endDate',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('No Of Bills: 2'),
                    Text('Total Sales: 50000'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              // Check the loading state of the controller
              if (SalesReportController.instance.isLoading.value) {
                // Display circular progress indicator while loading
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Check if the salesmaster list is empty after loading
              if (SalesReportController.instance.salesmaster.isEmpty) {
                // Display "No data Available" if the list is empty
                return Center(
                  child: Text(
                    'No data Available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }

              // Display the DataTable when data is available
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Full border radius
                  ),
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.blue.shade900),
                        columns: const [
                          DataColumn(
                              label: Text(
                            'BILL NO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          // DataColumn(
                          //     label: Text(
                          //   'ITEM NAME',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white),
                          // )),
                          DataColumn(
                              label: Text(
                            'QTY',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          // DataColumn(
                          //     label: Text(
                          //   'SELL RATE',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.white),
                          // )),
                          DataColumn(
                              label: Text(
                            'TOTAL PRICE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ],
                        rows: SalesReportController.instance.salesmaster
                            .map((sale) {
                          return DataRow(
                            cells: [
                              DataCell(Text(sale['BILLNO'].toString())),
                              // DataCell(Text(sale['ITEMNAME_ENG'] ?? 'No Name')),
                              DataCell(Text(sale['QUANTITY'].toString())),
                              // DataCell(Text(sale['SELL_RATE'].toString())),
                              DataCell(Text(sale['TOTAL_PRICE'].toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            })
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

class BillData {
  final int billno;
  final String billDate;
  final String customerName;
  final int qty;
  final double netAmount;

  BillData({
    required this.billno,
    required this.billDate,
    required this.customerName,
    required this.qty,
    required this.netAmount,
  });
}
