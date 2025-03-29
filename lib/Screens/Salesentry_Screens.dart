import 'package:bneedsbillappnew/Bluethooth_Connection/Bluethooth.dart';
import 'package:bneedsbillappnew/Bluethooth_Connection/Bluetooth_Connection.dart';
import 'package:bneedsbillappnew/Bluethooth_Connection/Class_Bluetooth.dart';
import 'package:bneedsbillappnew/Controller/Salesentry_Controller.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:bneedsbillappnew/Widgets/Common_Gridlayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesentryScreens extends StatefulWidget {
  const SalesentryScreens({super.key});

  @override
  State<SalesentryScreens> createState() => _SalesentryScreensState();
}

class _SalesentryScreensState extends State<SalesentryScreens> {
  final controller = Get.put(SalesentryController());
  double totalPrice = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> submitToDatabase() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
      commonUtils.log.i('LUsernmae  == $LUsernmae');
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      final selectedItems = controller.selectedItems;

      if (selectedItems.isEmpty) {
        commonUtils.log.e('No items selected');
        return;
      }

      final Companyemail = FirebaseAuth.instance.currentUser?.email;

      if (Companyemail == null) {
        commonUtils.log.e('User is not authenticated');
        return;
      }

      // Fetch company profile based on email
      QuerySnapshot companyProfileSnapshot = await FirebaseFirestore.instance
          .collection('COMPANY_REGISTER')
          .where('EMAILID', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      if (companyProfileSnapshot.docs.isNotEmpty) {
        String activeStatus =
            companyProfileSnapshot.docs.first.get('ACTIVE') ?? '';

        WriteBatch batch = FirebaseFirestore.instance.batch();
        List<Map<String, dynamic>> salesData = [];

        for (var item in selectedItems) {
          double sellRate =
              double.tryParse(item['SELL_RATE'].toString()) ?? 0.0;
          int quantity = int.tryParse(item['quantity'].toString()) ?? 0;
          double gst = double.tryParse(item['GST'].toString()) ?? 0.0;

          double totalPrice = sellRate * quantity;
          double gstAmount = (sellRate * quantity * gst) / (100 + gst);
          gstAmount = double.parse(gstAmount.toStringAsFixed(2));

          DocumentReference docRef =
              FirebaseFirestore.instance.collection('SALES_MASTER').doc();

          Map<String, dynamic> salesEntry = {
            'EMAILID_COMPANY': Companyemail,
            'USERNAME': LUsernmae,
            'ITEMNAME_ENG': item['ITEMNAME_ENG'] ?? '',
            'ITEMNAME_TAM': item['ITEMNAME_TAM'] ?? '',
            'MRP': item['MRP'] ?? 0.0,
            'GST': item['GST'] ?? 0.0,
            'SELL_RATE': item['SELL_RATE'] ?? 0.0,
            'DATE': formattedDate.toString(),
            'BILLNO': controller.billNumber.value,
            'QTY': item['quantity'],
            'TOTAL_PRICE': totalPrice,
            'GST_AMOUNT': gstAmount,
          };

          batch.set(docRef, salesEntry);
          salesData.add(salesEntry);
        }

        CommonPrintVariables.SalesData = salesData;
        await batch.commit();
        commonUtils.log.i('Data submitted successfully');
        controller.selectedItems.clear();

        if (activeStatus == 'Y') {
          bool isConnected = await PrintBluetoothThermal.connectionStatus;
          if (isConnected) {
            BluetoothConnection(items: salesData).printInvoice(context);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => bluetooth()));
          }
        } else {
          commonUtils.log.i('saving data.');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SalesentryScreens()));
        }
      } else {
        commonUtils.log.e('Company profile not found for the provided email.');
      }
    } catch (e) {
      commonUtils.log.e('Error submitting data: $e');
    }
  }

  /*Future<void> submitToDatabase() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final LUsernmae = prefs.getString('PREFSUSERNAME') ?? '';
      commonUtils.log.i('LUsernmae  == $LUsernmae');
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      final selectedItems = controller.selectedItems;

      if (selectedItems.isEmpty) {
        // You can show an error message here if no items are selected.
        return;
      }

      final Companyemail = FirebaseAuth.instance.currentUser?.email;

      if (Companyemail == null) {
        commonUtils.log.e('User is not authenticated');
        return;
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Initialize the list to store data for CommonPrintVariables
      List<Map<String, dynamic>> salesData = [];

      for (var item in selectedItems) {
        double sellRate = double.tryParse(item['SELL_RATE'].toString()) ?? 0.0;
        int quantity = int.tryParse(item['quantity'].toString()) ?? 0;
        double gst = double.tryParse(item['GST'].toString()) ?? 0.0;

        // Calculate the total price for the item (excluding GST)
        double totalPrice = sellRate * quantity;

        // Apply the formula for GST
        double gstAmount = (sellRate * quantity * gst) / (100 + gst);
        gstAmount = double.parse(gstAmount.toStringAsFixed(2));

        DocumentReference docRef =
            FirebaseFirestore.instance.collection('SALES_MASTER').doc();

        Map<String, dynamic> salesEntry = {
          'EMAILID_COMPANY': Companyemail,
          'USERNAME': LUsernmae,
          'ITEMNAME_ENG': item['ITEMNAME_ENG'] ?? '',
          'ITEMNAME_TAM': item['ITEMNAME_TAM'] ?? '',
          'MRP': item['MRP'] ?? 0.0,
          'GST': item['GST'] ?? 0.0,
          'SELL_RATE': item['SELL_RATE'] ?? 0.0,
          'DATE': formattedDate.toString(),
          'BILLNO': controller.billNumber.value,
          'QTY': item['quantity'],
          'TOTAL_PRICE': totalPrice,
          'GST_AMOUNT': gstAmount, // Add the GST amount to the entry
        };

        // Add the sales entry to the Firestore batch
        batch.set(docRef, salesEntry);

        salesData.add(salesEntry);
      }

      // Update the common variable with the sales data
      CommonPrintVariables.SalesData = salesData;
      commonUtils.log
          .i('THIS IS COMMON VARIABLE = ${CommonPrintVariables.SalesData}');
      // Commit the Firestore batch
      await batch.commit();

      commonUtils.log.i('Data submitted successfully');
      controller.selectedItems.clear();

      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        BluetoothConnection(items: salesData).printInvoice(context);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => bluetooth()));
      }
    } catch (e) {
      commonUtils.log.e('Error submitting data: $e');
    }
  }*/

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommonBottomnavigation())),
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            )),
        title: const Text(
          'SALES ENTRY',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Left Panel: Filtered Items
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildCategorySelector(),
              Expanded(
                child: Obx(() {
                  return controller.filteredItems.isEmpty
                      ? _buildEmptyFilteredView()
                      : _buildFilteredGrid();
                }),
              ),
            ],
          ),
        ),
        // Right Panel: Selected Items
        Expanded(
          flex: 2,
          child: _buildSelectedItemsList(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildCategorySelector(),
        Expanded(
          child: Obx(() {
            return controller.filteredItems.isEmpty
                ? _buildEmptyFilteredView()
                : _buildFilteredGrid();
          }),
        ),
        Expanded(
          child: _buildSelectedItemsList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      return controller.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () => controller.filterItemsByCategory(category),
                      child: Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  controller.selectedCategory.value == category
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.selectedCategory.value ==
                                          category
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
            );
    });
  }

  Widget _buildEmptyFilteredView() {
    return Center(
      child: Text(
        controller.selectedCategory.value.isEmpty
            ? 'Select a category to see items'
            : 'No items available for this category',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFilteredGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: C_Gridlayout(
          itemcount: controller.filteredItems.length,
          itemBuilder: (context, index) {
            final item = controller.filteredItems[index];
            return GestureDetector(
              onTap: () => controller.addItem(item),
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item['ITEMNAME_TAM']?.isNotEmpty == true
                                ? item['ITEMNAME_TAM']
                                : item['ITEMNAME_ENG']) ??
                            '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                      Text(
                        'Rs: ${item['SELL_RATE'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedItemsList() {
    return Obx(() {
      return controller.selectedItems.isEmpty
          ? const Center(child: Text('No items selected'))
          : ListView.builder(
              itemCount: controller.selectedItems.length,
              itemBuilder: (context, index) {
                final selectedItem = controller.selectedItems[index];
                final quantity =
                    int.tryParse(selectedItem['quantity'].toString()) ?? 0;
                final sellRate = double.tryParse(
                        selectedItem['SELL_RATE']?.toString() ?? '0') ??
                    0.0;
                final totalPrice = quantity * sellRate;

                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      controller.selectedItems.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 2,
                    color: Colors.blue.shade50,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedItem['ITEMNAME_ENG'] ?? 'N/A',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 5),
                                Text('Rate: Rs $sellRate'),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  controller.updateQuantity(index, false);
                                },
                              ),
                              Text('$quantity',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _showQuantityInputDialog(index);
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Rs $totalPrice',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }

  void _showQuantityInputDialog(int index) {
    final TextEditingController qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Quantity'),
          content: TextField(
            autofocus: true,
            controller: qtyController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _handleQuantitySubmission(context, index, qtyController);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleQuantitySubmission(context, index, qtyController);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleQuantitySubmission(
      BuildContext context, int index, TextEditingController qtyController) {
    final int? newQuantity = int.tryParse(qtyController.text);
    if (newQuantity != null && newQuantity > 0) {
      controller.updateQuantityWithValue(index, newQuantity);
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg: "Please enter a valid quantity",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Obx(() {
        final totalQuantity = controller.selectedItems.fold<int>(
          0,
          (sum, item) => sum + (int.tryParse(item['quantity'].toString()) ?? 0),
        );
        final totalAmount = controller.selectedItems.fold<double>(
          0.0,
          (sum, item) {
            final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
            final sellRate =
                double.tryParse(item['SELL_RATE']?.toString() ?? '0') ?? 0.0;
            return sum + (quantity * sellRate);
          },
        );
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Qty: $totalQuantity',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () {
                      if (controller.selectedItems.isNotEmpty) {
                        controller.incrementBillNumber();
                        submitToDatabase();
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please choose any item",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Text(
                'Tt:${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }),
    );
  }
}
