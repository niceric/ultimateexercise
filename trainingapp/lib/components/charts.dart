import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/enums.dart' as app_enums;
import 'package:intl/intl.dart';
import 'package:trainingapp/models/workout_model.dart';

class LineChartWithDropdown extends StatelessWidget {
  final app_enums.Metric selectedMetric;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Workout> workouts;

  LineChartWithDropdown({
    required this.selectedMetric,
    this.startDate,
    this.endDate,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: LineChart(
        mainData(),
      ),
    );
  }
  // Skapar en widget för titlar på x-axeln
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    if (startDate != null) {
      DateTime date = startDate!.add(Duration(days: value.toInt()));
      String formattedDate = DateFormat('dd/MM').format(date);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(formattedDate, style: style),
      );
    } else {
      return Text(value.toInt().toString(), style: style);
    }
  }
  // Skapar en widget för titlar på y-axeln
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Text(value.toInt().toString(), style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];

    // Skapa spots dynamiskt baserat på selectedMetric och workouts
    for (var workout in workouts) {
      if (workout.date != null && startDate != null && endDate != null) {
        int daysSinceStart = workout.date!.difference(startDate!).inDays;

        double yValue = 0;
        switch (selectedMetric) {
          case app_enums.Metric.Reps:
            yValue = workout.exercises
                .fold(0, (sum, exercise) => sum + exercise.sets.fold(0, (sum, set) => sum + set.reps))
                .toDouble();
            break;
          case app_enums.Metric.Sets:
            yValue = workout.exercises
                .fold(0, (sum, exercise) => sum + exercise.sets.length)
                .toDouble();
            break;
          case app_enums.Metric.Weight:
            yValue = workout.exercises
                .fold(0.0, (sum, exercise) => sum + exercise.sets.fold(0.0, (sum, set) => sum + set.weight))
                .toDouble();
            break;
        }

        // Lägg till spot om yValue är större än 0
        if (yValue > 0) {
          spots.add(FlSpot(daysSinceStart.toDouble(), yValue));
        }
      }
    }

    // Bestäm maxY dynamiskt för att få en bra marginal
    double maxY = spots.isNotEmpty
        ? (spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2).ceilToDouble()
        : 10;

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
      maxY: maxY,
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