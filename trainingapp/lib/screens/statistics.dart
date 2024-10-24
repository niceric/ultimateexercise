import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  
import 'package:trainingapp/components/bottom_appbar.dart';
import '../components/charts.dart';
import '../components/enums.dart' as app_enums;  // Använd alias för enums

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Statisticspage(),
    );
  }
}

class Statisticspage extends StatefulWidget {
  @override
  _StatisticspageState createState() => _StatisticspageState();
}

class _StatisticspageState extends State<Statisticspage> {
  app_enums.Metric selectedMetric = app_enums.Metric.Reps;  // Standard val för dropdown
  DateTimeRange? selectedDateRange;  // Datumintervall för grafen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StatisticspageContent(
        selectedMetric: selectedMetric,
        selectedDateRange: selectedDateRange,
        onMetricChanged: (newMetric) {
          setState(() {
            selectedMetric = newMetric;
          });
        },
        onDateRangeChanged: (newDateRange) {
          setState(() {
            selectedDateRange = newDateRange;
          });
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}

class StatisticspageContent extends StatelessWidget {
  final app_enums.Metric selectedMetric;
  final DateTimeRange? selectedDateRange;
  final ValueChanged<app_enums.Metric> onMetricChanged;
  final ValueChanged<DateTimeRange?> onDateRangeChanged;

  StatisticspageContent({
    required this.selectedMetric,
    required this.selectedDateRange,
    required this.onMetricChanged,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rad för att placera dropdown och datumväljare bredvid varandra
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Dropdown för val av data Reps, Sets och Weight
              Expanded(
                child: DropdownButton<app_enums.Metric>(
                  value: selectedMetric,
                  items: app_enums.Metric.values.map((app_enums.Metric value) {
                    return DropdownMenuItem<app_enums.Metric>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (app_enums.Metric? newValue) {
                    if (newValue != null) {
                      onMetricChanged(newValue);
                    }
                  },
                  isExpanded: true,
                ),
              ),
              // Datumväljare för att välja datumintervall
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDateRange) {
                      onDateRangeChanged(picked);
                    }
                  },
                  child: Text(
                    selectedDateRange == null
                        ? 'Välj datum'
                        : '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LineChartWithDropdown(
            selectedMetric: selectedMetric,
            startDate: selectedDateRange?.start,
            endDate: selectedDateRange?.end,
          ),
        ),
      ],
    );
  }
}