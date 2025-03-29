import 'package:flutter/material.dart';

class C_BottomthemedataPages{
   C_BottomthemedataPages._();

   static BottomSheetThemeData lightbottomSheetThemeData = BottomSheetThemeData(
     showDragHandle: true,
     backgroundColor:  Colors.white,
     modalBackgroundColor: Colors.white,
     constraints: const BoxConstraints(minWidth: double.infinity),
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
   );
   static BottomSheetThemeData darkbottomSheetThemeData = BottomSheetThemeData(  showDragHandle: true,
       backgroundColor:  Colors.black,
       modalBackgroundColor: Colors.black,
       constraints: const BoxConstraints(minWidth: double.infinity),
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
}