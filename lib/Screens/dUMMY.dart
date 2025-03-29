import 'package:bneedsbillappnew/Widgets/Common_Gridlayout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../Controller/Dummy_Controller.dart';

class Dummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Homecontroller());
    List<String> imageUrls = [
      'http://bneeds.in/BneedsoutletApi/images/image1.jpg',
      'http://bneeds.in/BneedsoutletApi/images/image2.jpg',
      'http://bneeds.in/BneedsoutletApi/images/image3.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome!', style: TextStyle(fontSize: 15)),
            SizedBox(height: 5),
            Text('VIGNESH KUMAR',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CarouselSlider(
                    /*Network code*/
                    /*CarouselSlider(
                      items: imageUrls.map((url) {
                        return T_RoundImage(
                          fit: BoxFit.contain,
                          Imgurl: url,
                          isNetWorkingImage: true, // Set to true for network images
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 0.9,
                        onPageChanged: (index, _) =>
                            controller.updatePageIndicator(index),
                      ),
                    ),*/
                    items: [
                      T_RoundImage(
                        fit: BoxFit.contain,
                        Imgurl: 'assets/images/Add1.jpg',
                      ),
                      T_RoundImage(
                        fit: BoxFit.contain,
                        Imgurl: 'assets/images/Add1.jpg',
                      ),
                    ],
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 0.9,
                      height: 150,
                      onPageChanged: (index, _) =>
                          controller.updatePageIndicator(index),
                    )),
              ),
              Center(
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < imageUrls.length; i++)
                        T_RoundContainer(
                          widht: 20,
                          Height: 4,
                          Margin: EdgeInsets.only(right: 10),
                          backgroundcolors:
                              controller.carousalCurrentIndex.value == i
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class T_RoundImage extends StatelessWidget {
  const T_RoundImage({
    super.key,
    required this.Imgurl,
    this.height = 50, // Default height for medium size
    this.applyImageradius = true,
    this.border,
    this.backgroundcolor,
    this.fit = BoxFit.cover, // Use BoxFit.cover for better fitting images
    this.padding,
    this.isNetWorkingImage = false,
    this.onPressed,
    this.borderradius = 20, // Adjusted to a larger, medium-sized radius
  });

  final String Imgurl;
  final double? height;
  final bool applyImageradius;
  final BoxBorder? border;
  final Color? backgroundcolor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final double borderradius;
  final bool isNetWorkingImage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border ??
              Border.all(color: Colors.grey.shade300), // Adds a subtle border
          color: backgroundcolor ?? Colors.white, // Default background color
          borderRadius: applyImageradius
              ? BorderRadius.circular(borderradius)
              : BorderRadius.zero,
        ),
        child: ClipRRect(
          borderRadius: applyImageradius
              ? BorderRadius.circular(borderradius)
              : BorderRadius.zero,
          child: Image(
            image: isNetWorkingImage
                ? NetworkImage(Imgurl)
                : AssetImage(Imgurl) as ImageProvider,
            fit: fit, // Fit set for better appearance
          ),
        ),
      ),
    );
  }
}

class T_RoundContainer extends StatelessWidget {
  const T_RoundContainer({
    super.key,
    this.Margin,
    this.widht,
    this.Height,
    this.radius = 16,
    this.child,
    this.backgroundcolors = Colors.white,
    this.showBorder = false,
    this.bordercolor = Colors.blue,
    this.padding,
  });

  final double? widht;
  final double? Height;
  final double radius;
  final EdgeInsets? Margin;
  final Widget? child;
  final Color backgroundcolors;
  final bool showBorder;
  final Color bordercolor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: Height,
      margin: Margin,
      padding: padding,
      decoration: BoxDecoration(
        border: showBorder ? Border.all(color: bordercolor) : null,
        borderRadius: BorderRadius.circular(radius),
        color: backgroundcolors,
      ),
      child: child,
    );
  }
}
