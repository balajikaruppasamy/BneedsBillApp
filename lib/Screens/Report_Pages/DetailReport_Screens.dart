import 'package:flutter/material.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class  DetailreportScreens  extends StatefulWidget {
  const DetailreportScreens({super.key});

  @override
  State<DetailreportScreens> createState() => _DetailreportScreensState();
}

class _DetailreportScreensState extends State<DetailreportScreens> {
  TextEditingController searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedUser;
  List<String> usersList = [];
  int totalBills = 0;
  double totalSales = 0.0;
  bool isFilterVisible = false;
  double grandTotal = 0.0; // Initialize the grand total
  @override
  void initState() {
    super.initState();
    _toDate = DateTime.now();
    _fromDate = DateTime.now();
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

  Stream<QuerySnapshot> getSalesDataStream() {
    if (_fromDate == null || _toDate == null) {
      return Stream.empty();
    }
    String fromDateString = DateFormat('dd/MM/yyyy').format(_fromDate!);
    String toDateString = DateFormat('dd/MM/yyyy').format(_toDate!);

    return FirebaseFirestore.instance
        .collection('SALES_MASTER')
        .where("EMAILID_COMPANY",
            isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where("DATE", isGreaterThanOrEqualTo: fromDateString)
        .where("DATE", isLessThanOrEqualTo: toDateString)
        .orderBy('BILLNO')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFilterVisible = !isFilterVisible;
                });
              },
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            ),
          ],
          title: const Text('USER REPORTS',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Colors.blue.shade900,
          leading: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommonBottomnavigation()),
            ),
            icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            if (isFilterVisible)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectFromDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                hintText: _fromDate != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(_fromDate!)
                                    : 'From',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectToDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                hintText: _toDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_toDate!)
                                    : 'To-Date',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getSalesDataStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                              height: 400,
                              fit: BoxFit.cover,
                            ),
                            const Text('No Data available for this Report'),
                          ],
                        ),
                      );
                    }

                    final salesData = snapshot.data!.docs;

                    // Group sales data by BILLNO
                    Map<String, List<Map<String, dynamic>>> groupedData = {};
                    for (var doc in salesData) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String billNo = (data['BILLNO'] ?? '')
                          .toString(); // Fixing type conversion

                      if (groupedData.containsKey(billNo)) {
                        groupedData[billNo]!.add(data);
                      } else {
                        groupedData[billNo] = [data];
                      }
                    }

                    totalBills = groupedData.length;
                    totalSales = salesData.fold(
                        0.0, (sum, doc) => sum + (doc['TOTAL_PRICE'] ?? 0.0));

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: groupedData.length,
                            itemBuilder: (context, index) {
                              String billNo = groupedData.keys.elementAt(index);
                              List<Map<String, dynamic>> items =
                                  groupedData[billNo]!;

                              // Aggregate item names
                              String itemNames = items
                                  .map((item) =>
                                      item['ITEMNAME_ENG']?.toString() ??
                                      'Unknown')
                                  .join(', ');

                              // Use first item data for date and username
                              String date =
                                  items.first['DATE']?.toString() ?? '';
                              String userName =
                                  items.first['USERNAME']?.toString() ??
                                      'Unknown';

                              // Calculate total price for this bill
                              double totalBillPrice = items.fold(
                                  0.0,
                                  (sum, item) =>
                                      sum +
                                      (item['TOTAL_PRICE']?.toDouble() ?? 0.0));
                              grandTotal +=
                                  totalBillPrice; // Add bill total to grand total

                              return Card(
                                elevation: 5,
                                color: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: ListTile(
                                      title: Text(userName),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('B-No: $billNo'),
                                          Text('ITEMS: $itemNames'),
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(date),
                                          const SizedBox(height: 10),
                                          Text(
                                              'TOTAL: $totalBillPrice'), // Total for this bill
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
