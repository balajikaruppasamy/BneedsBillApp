import 'package:bneedsbillappnew/Screens/Company_Profile.dart';
import 'package:bneedsbillappnew/Screens/Dashboard_Screens.dart';
import 'package:bneedsbillappnew/Screens/Front_Screens.dart';
import 'package:bneedsbillappnew/Screens/Item_Screen.dart';
import 'package:bneedsbillappnew/Screens/Salesentry_Screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

class CommonBottomnavigation extends StatefulWidget {
  @override
  _CommonBottomnavigationState createState() => _CommonBottomnavigationState();
}

class _CommonBottomnavigationState extends State<CommonBottomnavigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 50, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = [
    FrontScreens(),
    ItemScreen(),
    CompanyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.box),
            label: 'Item',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8.0,
      ),
    );
  }
}
