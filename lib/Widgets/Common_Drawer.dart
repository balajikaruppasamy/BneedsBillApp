import 'package:bneedsbillappnew/Screens/Category_Screens.dart';
import 'package:bneedsbillappnew/Screens/Item_Screen.dart';
import 'package:bneedsbillappnew/Screens/Login_Screens.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/Billwise_Screens.dart';
import 'package:bneedsbillappnew/Screens/dUMMY.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/Logger.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 215,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100, // Set fixed height for the DrawerHeader
            color: Colors.blue.shade900, // You can set the background color
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'BNeeds Bill...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'SALES ENTRY',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {},
            leading: Icon(Icons.receipt),
          ),
          // ListTile(
          //   title: Text(
          //     'Search Sale Entry',
          //     style: TextStyle(fontSize: 15),
          //   ),
          //   leading: Icon(Icons.search),
          // ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text(
              'ADD ITEMS',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Get.to(() => ItemScreen());
              // Get.to(ItemScreen());
            },
            leading: Icon(Icons.production_quantity_limits),
          ),
          ListTile(
            title: Text(
              'ADD CATEGORY',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Get.to(CategoryScreens());
            },
            leading: Icon(Icons.category),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            onTap: () {
              Get.to(() => BillwiseScreens());
              // Get.to(ItemScreen());
            },
            title: Text(
              'BILL WISE REPORT',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.account_balance_wallet),
          ),
          ListTile(
            onTap: () {
              // Get.to(() => Dummy());
            },
            title: Text(
              'ITEM WISE REPORT',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.file_copy_sharp),
          ),
          ListTile(
            title: Text(
              'DATE WISE REPORT',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.date_range_rounded),
          ),
          ListTile(
            title: Text(
              'ITEM WITH BILL',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.file_copy),
          ),
          Divider(
            height: 2.0,
          ),
          /*   ListTile(
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.app_settings_alt),
          ),*/
          ListTile(
            title: Text(
              'LOG OUT',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () async {
              try {
                // Log out the current user
                await FirebaseAuth.instance.signOut();

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('PREFSUSERNAME');

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreens()));
              } catch (e) {
                // Handle error if something goes wrong
                commonUtils.log.e('Error logging out: $e');
              }
            },
            leading: Icon(Icons.logout),
          ),
          /*     ListTile(
            title: Text(
              'Backup',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.backup_sharp),
          ),*/
        ],
      ),
    );
  }
}
