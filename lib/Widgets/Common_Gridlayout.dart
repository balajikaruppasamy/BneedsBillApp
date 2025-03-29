import 'package:flutter/material.dart';

class C_Gridlayout extends StatefulWidget {
  const C_Gridlayout({
    super.key,
    required this.itemcount,
    this.mainAxisExtent = 200,
    required this.itemBuilder,
  });

  final int itemcount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  State<C_Gridlayout> createState() => _C_GridlayoutState();
}

class _C_GridlayoutState extends State<C_Gridlayout> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.itemcount,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,

          // crossAxisSpacing: C_Sizes.gridviewspcing,
          // mainAxisExtent: mainAxisExtent,
        ),
        itemBuilder: widget.itemBuilder);
  }
}
