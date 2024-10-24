import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/enums.dart' as app_enums;  // Använd alias för enums

class LineChartWithDropdown extends StatelessWidget {
  final app_enums.Metric selectedMetric;  // Data som ska visas Reps, Sets och Weight
  final DateTime? startDate; 
  final DateTime? endDate;    

  LineChartWithDropdown({required this.selectedMetric, this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: LineChart(
        mainData(),  // Metod för att bygga grafen baserat på dropdown-värden och datumet
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    if (startDate != null && endDate != null) {
      DateTime date = startDate!.add(Duration(days: value.toInt()));
      text = Text(
        '${date.day}/${date.month}',
        style: style,
      );
    } else {
      text = Text(
        value.toInt().toString(),
        style: style,
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (selectedMetric == app_enums.Metric.Weight) {
      text = value.toInt().toString();
    } else {
      text = value.toInt().toString();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];

    switch (selectedMetric) {
      case app_enums.Metric.Reps:
        spots = [
          FlSpot(0, 3),
          FlSpot(1, 4),
          FlSpot(2, 2),
          FlSpot(3, 10),
          FlSpot(4, 3),
          FlSpot(5, 4),
        ];
        break;
      case app_enums.Metric.Sets:
        spots = [
          FlSpot(0, 1),
          FlSpot(1, 2),
          FlSpot(2, 2),
          FlSpot(3, 3),
          FlSpot(4, 2),
          FlSpot(5, 2),
        ];
        break;
      case app_enums.Metric.Weight:
        spots = [
          FlSpot(0, 60),
          FlSpot(1, 65),
          FlSpot(2, 68),
          FlSpot(3, 70),
          FlSpot(4, 73),
          FlSpot(5, 78),
        ];
        break;
    }

    // Hitta det högsta värdet i spots för att dynamiskt justera maxY
    double maxYValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    double maxY = (maxYValue * 1.2).ceilToDouble(); // Lägg till 20% marginal

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: selectedMetric == app_enums.Metric.Weight ? 10 : 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: selectedMetric == app_enums.Metric.Weight ? 10 : 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: startDate != null && endDate != null
          ? endDate!.difference(startDate!).inDays.toDouble()
          : 6,
      minY: 0,
      maxY: maxY, // Dynamisk justering av maxY
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 4,
          color: Colors.blue,
        ),
      ],
    );
  }
}