import 'package:bneedsbillappnew/Controller/Salesentry_Controller.dart';
import 'package:bneedsbillappnew/Controller/Signup_Controller.dart';
import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Screens/Login_Screens.dart';
import 'package:bneedsbillappnew/Screens/Salesentry_Screens.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final controller = Get.put(SignupController());
  bool _isEditing = false;
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _onUpdatePressed(BuildContext context) {
    if (_isEditing) {
      // Call the update function to save the data
      controller.updateCompanyDetails().then((_) {
        _toggleEditing();
      }).catchError((error) {
        // Handle error if needed
        Fluttertoast.showToast(msg: "Failed to save details: $error");
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> Logouts() async {
    try {
      await FirebaseAuth.instance.signOut();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('PREFSUSERNAME');
      await prefs.setBool('isLoggedIn', false); // Reset login state
      await prefs.setBool('isUserLogin', false); // Reset user login state

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreens()),
      );
    } catch (e) {
      // Handle the error appropriately
      commonUtils.log.e('Error logging out: $e');
    }
  }

  Future<void> Logout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Logouts();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      try {
        await FirebaseAuth.instance.signOut();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('PREFSUSERNAME');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreens()),
        );
      } catch (e) {
        commonUtils.log.e('Error logging out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final Bill = Get.put(SalesentryController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Company Details'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommonBottomnavigation()));
            },
            icon: Icon(Icons.arrow_back_ios_sharp)),
        actions: [
          IconButton(
            onPressed: () {
              if (_isEditing) {
                // _OnUpdatePressed(context); // Save the data
              } else {
                _toggleEditing(); // Enter edit mode
              }
            },
            icon: Icon(
              _isEditing ? null : Icons.edit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: Column(
                    //     children: [
                    //       CircleAvatar(
                    //         radius: 50,
                    //         backgroundColor: Colors.grey[300],
                    //         child: Icon(Icons.add_photo_alternate, size: 50),
                    //       ),
                    //       SizedBox(height: 8),
                    //       Text('Upload Company Logo'),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    TextField(
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w900),
                      controller: controller.Companyname,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.business,
                            color: Colors.black,
                          ),
                          hintText: 'Business/Company Name'),
                    ),
                    SizedBox(height: 5),

                    TextField(
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w900),
                      controller: controller.gst,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.receipt, color: Colors.black),
                        hintText: 'GST Number',
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w900),
                      controller: controller.Emailid,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Business Email id',
                        prefixIcon: Icon(Icons.mail, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w900),
                      controller: controller.Phonenumber,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                        hintText: 'Business Phn No',
                        prefixIcon: Icon(Icons.phone, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Business Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w900),
                      controller: controller.Streetname,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(
                          hintText: 'Address1',
                          prefixIcon:
                              Icon(Iconsax.location, color: Colors.black)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w900),
                            controller: controller.Address,
                            readOnly: !_isEditing,
                            decoration: InputDecoration(
                                hintText: 'Address2',
                                prefixIcon: Icon(Iconsax.location,
                                    color: Colors.black)),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w900),
                            controller: controller.City,
                            readOnly: !_isEditing,
                            decoration: InputDecoration(
                                labelText: 'City',
                                hintText: 'City',
                                prefixIcon: Icon(Iconsax.location,
                                    color: Colors.black)),
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(height: 20),
                    // Text('Billing Address',
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    // TextField(
                    //   decoration: InputDecoration(labelText: 'Billing Address'),
                    // ),
                    //
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Bill No:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              style: TextStyle(
                  color: Colors.blue.shade900, fontWeight: FontWeight.w900),
              controller: Bill.resetbillno,
              readOnly: !_isEditing,
              decoration: InputDecoration(hintText: 'Re-start Bill No'),
            ),
            SizedBox(height: 20),
            Text('Print Footer:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              style: TextStyle(
                  color: Colors.blue.shade900, fontWeight: FontWeight.w900),
              controller: controller.Footernmae,
              readOnly: !_isEditing,
              decoration: InputDecoration(hintText: 'Footer Name'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                Logout();
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Log out',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                      ),
                      Icon(Icons.logout, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  int newBillNumber = int.tryParse(Bill.resetbillno.text) ??
                      0; // Get the value from the TextField and convert it to an int
                  if (newBillNumber > 0) {
                    SalesentryController.instance.restBillNumber(
                        newBillNumber); // Call the restBillNumber function
                  } else {
                    // Show an error or prompt to the user
                    Get.snackbar("Error", "Please enter a valid bill number.");
                  }
                  _onUpdatePressed(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Save & Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
