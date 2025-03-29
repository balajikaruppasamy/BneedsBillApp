import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SaleOverviewGraph extends StatefulWidget {
  const SaleOverviewGraph({super.key});

  @override
  State<SaleOverviewGraph> createState() => _SaleOverviewGraphState();
}

class _SaleOverviewGraphState extends State<SaleOverviewGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: 300,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                          dataSource: <_SalesData>[
                            _SalesData('Jan', 35),
                            _SalesData('Feb', 28),
                            _SalesData('Mar', 34),
                            _SalesData('Apr', 32),
                            _SalesData('jun', 40),
                            _SalesData('jul', 100),
                          ],
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales)
                    ]))));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
