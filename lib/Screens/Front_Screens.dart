import 'package:bneedsbillappnew/Controller/Dummy_Controller.dart';
import 'package:bneedsbillappnew/Controller/Salesreports_Conroller.dart';
import 'package:bneedsbillappnew/Controller/UserDetail_Controller.dart';
import 'package:bneedsbillappnew/Screens/Category_Screens.dart';
import 'package:bneedsbillappnew/Screens/Company_Profile.dart';
import 'package:bneedsbillappnew/Screens/Item_Screen.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/Billwise_Screens.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/Datewise_Screens.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/Itemwise_Screen.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/Userwise_All_Report.dart';
import 'package:bneedsbillappnew/Screens/Report_Pages/DetailReport_Screens.dart';
import 'package:bneedsbillappnew/Screens/Salesentry_Screens.dart';
import 'package:bneedsbillappnew/Screens/User_Detail_Screens.dart';
import 'package:bneedsbillappnew/Screens/dUMMY.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class FrontScreens extends StatefulWidget {
  const FrontScreens({super.key});

  @override
  State<FrontScreens> createState() => _FrontScreensState();
}

class _FrontScreensState extends State<FrontScreens> {
  ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true; // Flag to track the visibility of the FAB
  List<String> imageUrls = [
    'https://www.bneedsbill.com/flutterimg/image1.jpeg',
    'https://www.bneedsbill.com/flutterimg/image2.jpg',
    'https://www.bneedsbill.com/flutterimg/image3.jpg',
  ];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isFabVisible = false; // Hide FAB when scrolling down
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isFabVisible = true; // Show FAB when scrolling up
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Slidercontroller = Get.put(Homecontroller());
    final controller = Get.put(UserdetailController());
    final sales = Get.put(SalesreportsConroller());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('assets/images/investment.gif')),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome!', style: TextStyle(fontSize: 15)),
                SizedBox(height: 8),
                Obx(() => Text('${controller.Username.value}',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.blue.shade700,
                    ))),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Obx(
              //         () => Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         for (int i = 0; i < 4; i++)
              //           T_RoundContainer(
              //             widht: 20,
              //             Height: 3,
              //             Margin: EdgeInsets.only(right: 10),
              //             backgroundcolors:
              //             Slidercontroller.carousalCurrentIndex.value == i
              //                 ? Colors.blue
              //                 : Colors.grey,
              //           ),
              //       ],
              //     ),
              //   ),
              // ),
              Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today Sales',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            Obx(() => Text(
                                  '${sales.todayTotalAmount.value}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today Bills',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            Obx(() => Text(
                                  '${sales.todayTotalBills.value}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    CarouselSlider(
                      items: imageUrls.map((url) {
                        return T_RoundImage(
                          onPressed: () async {
                            var url = Uri.parse(
                                'https://www.nminfotechsolutions.com/');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              commonUtils.log.i('Could not launch $url');
                            }
                          },
                          fit: BoxFit.contain,
                          Imgurl: url,
                          isNetWorkingImage: true,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 0.7,
                        height: 150,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, _) {
                          Slidercontroller.updatePageIndicator(index);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < 3; i++)
                              T_RoundContainer(
                                widht: 20,
                                Height: 3,
                                Margin: EdgeInsets.only(right: 10),
                                backgroundcolors: Slidercontroller
                                            .carousalCurrentIndex.value ==
                                        i
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                          ],
                        ),
                      ),
                    ),
                    // CarouselSlider(
                    //     /*Network code*/
                    //     /*CarouselSlider(
                    //         items: imageUrls.map((url) {
                    //           return T_RoundImage(
                    //             fit: BoxFit.contain,
                    //             Imgurl: url,
                    //             isNetWorkingImage: true, // Set to true for network images
                    //           );
                    //         }).toList(),
                    //         options: CarouselOptions(
                    //           autoPlay: true,
                    //           viewportFraction: 0.9,
                    //           onPageChanged: (index, _) =>
                    //               controller.updatePageIndicator(index),
                    //         ),
                    //       ),*/
                    //     items: [
                    //       T_RoundImage(
                    //         fit: BoxFit.cover,
                    //         Imgurl: 'assets/images/Add1.jpg',
                    //       ),
                    //     ],
                    //     options: CarouselOptions(
                    //       autoPlay: true,
                    //       viewportFraction: 0.8,
                    //       height: 140,
                    //       autoPlayCurve: Curves.fastOutSlowIn,
                    //       onPageChanged: (index, _) =>
                    //           Slidercontroller.updatePageIndicator(index),
                    //     )),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('REPORTS',
                  style: GoogleFonts.play(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 8),
              Card(
                color: Colors.white,
                elevation: 2,
                child: Column(
                  children: [
                    _buildIconRow([
                      _buildIconButton('Bill wise', Iconsax.receipt,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BillwiseScreens()),
                        );
                      }),
                      _buildIconButton('Item wise', Iconsax.shopping_cart,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemwiseScreen()),
                        );
                      }),
                      _buildIconButton('Date wise', Iconsax.calendar,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DatewiseScreens()),
                        );
                      }),
                      _buildIconButton('Details', Icons.data_usage,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailreportScreens()),
                        );
                      }),
                      _buildIconButton('Users', Iconsax.people, onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserwiseAllReport()),
                        );
                      }),
                    ]),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('MASTER',
                  style: GoogleFonts.play(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1)),
              SizedBox(height: 15),
              Card(
                color: Colors.white,
                elevation: 2,
                child: Column(
                  children: [
                    _buildIconRow([
                      _buildIconButton('Company\n Creation', Iconsax.shop,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyProfile()),
                        );
                      }),
                      _buildIconButton('User\nCreation', Icons.people,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDetailScreens()),
                        );
                      }),
                      _buildIconButton('Catogory\nCreation', Iconsax.category,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreens()),
                        );
                      }),
                      _buildIconButton('Item\nCreation', Iconsax.shopping_bag,
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemScreen()),
                        );
                      }),
                    ]),
                  ],
                ),
              ),

              // GridView.count(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   crossAxisCount: 2,
              //   children: [
              //     _dashboardCard('Sales', 'Invoice/Sales Return/Print Bill'),
              //     _dashboardCard(
              //         'Customer', 'Manage your store customer information'),
              //     _dashboardCard('Products',
              //         'Create/Edit your store products information'),
              //     _dashboardCard(
              //         'Category', 'Manage your store products category'),
              //     _dashboardCard(
              //         'Inventory', 'Manage your store products stock'),
              //     _dashboardCard('Expense', 'Track your store expense details'),
              //     _dashboardCard('Expense', 'Track your store expense details'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isFabVisible
          ? Transform.translate(
              offset: Offset(0, -10), // Moves the FAB slightly up
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesentryScreens()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.blue,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.add,
                      size: 15,
                      color: Colors.white, // Icon color
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'New Sale',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildIconButton(String label, IconData icon,
      {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue, size: 25),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Widget _buildIconButton(String label, IconData icon) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       CircleAvatar(
  //         radius: 20,
  //         backgroundColor: Colors.blue.shade50,
  //         child: Icon(icon, color: Colors.blue, size: 20),
  //       ),
  //       SizedBox(height: 4),
  //       Text(
  //         label,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 12),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildIconRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  Widget _dashboardCard(String title, String subtitle) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(subtitle, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
