import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class saleBarChart extends StatefulWidget {
  final Map<String, double> saleDetail;

  saleBarChart({required this.saleDetail});

  @override
  State<saleBarChart> createState() => _saleBarChartState();
}

class _saleBarChartState extends State<saleBarChart> {
  int? showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generatedGroupData(int x, double y) {
    return BarChartGroupData(
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barsSpace: 0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          fromY: 0.0,
          width: 10,
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double>? SaleDetail = widget.saleDetail;

    List<String> DateList =
        SaleDetail!.isNotEmpty ? SaleDetail.keys.toList() : [];
    List<double> SaleList = SaleDetail!.values.toList();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        groupsSpace: 60,
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              //interval: 0,
              reservedSize: 35,
              //interval: 10,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= DateList.length) ;

                return Text(
                  DateList[index].replaceFirst(RegExp(r'\s+'), '\n'),
                  // softWrap: true,
                );

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        barGroups: List.generate(
          SaleDetail!.keys.length,
          (int index) => generatedGroupData(index, SaleList[index]),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchCallback: (event, response) {
            if (response != null &&
                response.spot != null &&
                event is FlTapUpEvent) {
              setState(() {
                final x = response.spot!.touchedBarGroup.x;
                final isshowing = showingTooltip == x;
                if (isshowing) {
                  showingTooltip = -1;
                } else {
                  showingTooltip = x;
                }
              });
            }
          },
          mouseCursorResolver: (event, response) {
            return response == null || response.spot == null
                ? MouseCursor.defer
                : SystemMouseCursors.click;
          },
        ),
      ),
    );
  }
}
