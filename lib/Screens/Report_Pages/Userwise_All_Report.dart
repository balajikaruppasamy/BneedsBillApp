import 'package:flutter/material.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserwiseAllReport extends StatefulWidget {
  const UserwiseAllReport({super.key});

  @override
  State<UserwiseAllReport> createState() => _UserwiseAllReportState();
}

class _UserwiseAllReportState extends State<UserwiseAllReport> {
  TextEditingController searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool isFilterVisible = false;

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
          title: const Text('USER ALL REPORTS',
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

                  // Group sales data by DATE and USERNAME
                  Map<String, Map<String, double>> dateUserTotalSales = {};
                  Map<String, Map<String, int>> dateUserTotalBills = {};

                  for (var doc in salesData) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String date = data['DATE']?.toString() ?? '';
                    double totalPrice = data['TOTAL_PRICE']?.toDouble() ?? 0.0;
                    String username = data['USERNAME'] ??
                        'Unknown'; // Assuming 'USERNAME' is a field

                    // Aggregate sales and bill count for each date and username
                    if (dateUserTotalSales.containsKey(date)) {
                      if (dateUserTotalSales[date]!.containsKey(username)) {
                        dateUserTotalSales[date]![username] =
                            dateUserTotalSales[date]![username]! + totalPrice;
                        dateUserTotalBills[date]![username] =
                            dateUserTotalBills[date]![username]! + 1;
                      } else {
                        dateUserTotalSales[date]![username] = totalPrice;
                        dateUserTotalBills[date]![username] = 1;
                      }
                    } else {
                      dateUserTotalSales[date] = {username: totalPrice};
                      dateUserTotalBills[date] = {username: 1};
                    }
                  }

                  return ListView.builder(
                    itemCount: dateUserTotalSales.length,
                    itemBuilder: (context, index) {
                      String date = dateUserTotalSales.keys.elementAt(index);
                      Map<String, double> userSales = dateUserTotalSales[date]!;
                      Map<String, int> userBills = dateUserTotalBills[date]!;

                      return Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${userSales.keys.first}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(date),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: userSales.keys.map((username) {
                                  double totalSales = userSales[username]!;
                                  int totalBills = userBills[username]!;

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Bills: $totalBills'),
                                      Text(
                                        'Total: ${totalSales.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
