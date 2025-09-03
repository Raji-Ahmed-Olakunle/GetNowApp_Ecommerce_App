import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'pie_indicator.dart';

class StarPieChart extends StatefulWidget {
  final Map<String, double> starDetail;
  const StarPieChart({required this.starDetail, Key? key}) : super(key: key);

  @override
  _StarPieChartState createState() => _StarPieChartState();
}

class _StarPieChartState extends State<StarPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              PieIndicator(color: Colors.blue, text: 'One Star', isSquare: true),
              PieIndicator(color: Colors.yellow, text: 'Two Star', isSquare: true),
              PieIndicator(color: Colors.purple, text: 'Three Star', isSquare: true),
              PieIndicator(color: Colors.green, text: 'Four Star', isSquare: true),
              PieIndicator(color: Colors.orangeAccent, text: 'Five Star', isSquare: true),
            ],
          ),
        ),
        const SizedBox(width: 28),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    final starDetail = widget.starDetail;
    final sum = starDetail['sum'] ?? 1;
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final value = starDetail['star${i + 1}'] ?? 0;
      return PieChartSectionData(
        color: [Colors.blue, Colors.yellowAccent, Colors.purple, Colors.green, Colors.orangeAccent][i],
        value: value,
        title: sum != 0 ? '${((value / sum) * 100).toStringAsFixed(1)}%' : '0%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          shadows: shadows,
        ),
      );
    });
  }
} 