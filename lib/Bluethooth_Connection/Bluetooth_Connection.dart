import 'package:bneedsbillappnew/Bluethooth_Connection/Bluethooth.dart';
import 'package:bneedsbillappnew/Bluethooth_Connection/Class_Bluetooth.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class bluetooth extends StatefulWidget {
  const bluetooth({super.key});

  @override
  State<bluetooth> createState() => _bluetoothState();
}

class _bluetoothState extends State<bluetooth> {
  String _msj = "";
  bool connected = false;
  final PrintBluetoothThermal _printer = PrintBluetoothThermal();
  List<String> connectedDevicesMac = [];

  String connectedDeviceMac = ""; // To track the connected device
  List<BluetoothInfo> items = [];
  bool _progress = false;
  String companyName = '';
  String companyAddress = '';
  String companyCity = '';
  String companyPhone = '';
  String Footername = '';
  String gstin = '';
  String streetname = '';
  int? BillNo;

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    getBluetoots();

    _fetchCompanyNameFromFirestore();
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msj = "Searching for paired devices...";
    });

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      _progress = false;
      items = listResult;
      _msj = items.isEmpty
          ? "No Bluetooth devices found. Please pair a device in settings."
          : "Tap on a device to connect or disconnect.";
    });
  }

  Future<void> connectOrDisconnect(String mac) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;

    if (connectionStatus && connectedDeviceMac == mac) {
      // Disconnect device
      await PrintBluetoothThermal.disconnect;
      setState(() {
        connectedDevicesMac.remove(mac);
        connectedDeviceMac = "";
        _msj = "Disconnected from $mac.";
      });
    } else {
      // Connect to device
      await connectToDevice(mac);
    }
  }

  Future<void> connectToDevice(String mac) async {
    setState(() {
      _progress = true;
      _msj = "Connecting to $mac...";
    });

    try {
      final bool result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);

      setState(() {
        _progress = false;
        if (result) {
          connectedDeviceMac = mac;
          connectedDevicesMac.add(mac);
          _msj = "Connected to $mac. Printing invoice...";
          BluetoothConnection(items: CommonPrintVariables.SalesData)
              .printInvoice(context);
        } else {
          connectedDeviceMac = mac;
          connectedDevicesMac.add(mac);
          _msj = "Connected to $mac. Printing invoice...";
          BluetoothConnection(items: CommonPrintVariables.SalesData)
              .printInvoice(context);
          // _msj = "Failed to connect to $mac.";
        }
      });
    } catch (e) {
      setState(() {
        _progress = false;
        _msj = "Error occurred while connecting: $e";
      });
    }
  }

  Future<void> _fetchCompanyNameFromFirestore() async {
    try {
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
        Footername = userData['FOOTERNMAE'] ?? 'N/A';
        gstin = userData['GST'] ?? 'N/A';
        streetname = userData['STREETNAME'] ?? 'N/A';
      } else {
        Fluttertoast.showToast(msg: 'No user found for this email!');
      }
    } catch (e) {
      commonUtils.log.e("Error fetching company data: $e");
      Fluttertoast.showToast(msg: 'Failed to fetch company data.');
    }
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blue.shade100,
        title: const Text(
          'Bluetooth Printer',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getBluetoots,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String mac = items[index].macAdress;
                  return ListTile(
                    onTap: () => connectOrDisconnect(mac),
                    title: Text('Name: ${items[index].name}'),
                    subtitle: Text(mac),
                    trailing: connectedDeviceMac == mac
                        ? Icon(Icons.bluetooth_connected, color: Colors.green)
                        : Icon(Icons.bluetooth, color: Colors.grey),
                  );
                },
              ),
            ),
            if (_progress) Center(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_msj, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
