import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatewiseScreens extends StatefulWidget {
  const DatewiseScreens({super.key});

  @override
  State<DatewiseScreens> createState() => _DatewiseScreensState();
}

class _DatewiseScreensState extends State<DatewiseScreens> {
  TextEditingController searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  int totalBills = 0;
  double totalSales = 0.0;
  bool invisiabledate = false;

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
                invisiabledate = !invisiabledate;
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
          'DATE WISE REPORT',
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
            if (invisiabledate)
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
            // Updated StreamBuilder and data grouping
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

                  // Initialize a map for grouping sales data by date
                  Map<String, Map<String, dynamic>> dateWiseSalesData = {};

                  final salesData = snapshot.data!.docs;
                  for (var doc in salesData) {
                    String date = doc['DATE'].toString();
                    var quantity = doc['QTY'] ?? 0.0;
                    var totalPrice = doc['TOTAL_PRICE'] ?? 0.0;

                    if (dateWiseSalesData.containsKey(date)) {
                      dateWiseSalesData[date]!['TOTAL_BILLS'] += 1;
                      dateWiseSalesData[date]!['TOTAL_AMOUNT'] += totalPrice;
                    } else {
                      dateWiseSalesData[date] = {
                        'TOTAL_BILLS': 1,
                        'TOTAL_AMOUNT': totalPrice,
                      };
                    }
                  }

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
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'DATE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Item Count',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                DataColumn(
                                    label: Text(
                                  'TOTAL AMOUNT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                              ],
                              rows: dateWiseSalesData.entries.map((entry) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(entry.key)),
                                    DataCell(Text(
                                        entry.value['TOTAL_BILLS'].toString())),
                                    DataCell(Text(entry.value['TOTAL_AMOUNT']
                                        .toString())),
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
