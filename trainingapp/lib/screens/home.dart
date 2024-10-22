import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:trainingapp/states/screen_index_provider.dart';
import 'package:trainingapp/components/weather_tile.dart';

//Hämtar månadens månad
String getCurrentMonth() {
  DateTime now = DateTime.now();
  String monthName = DateFormat('MMMM').format(now);
  return monthName;
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentMonth = getCurrentMonth();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Hem", style: TextStyle(fontSize: 45)),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(),
      body: Padding(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WeatherTile(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Good morning, User!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 40, // Öka denna senare
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentMonth,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 110,
                width: 175,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Skuggans färg
                      offset: Offset(2, 9),
                      blurRadius: 4, // Hur suddig skuggan ska vara
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 45,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Workout",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: calender(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget calender() {
  //Lista med dagar där man tränat
  List<DateTime> trainingDays = [
    DateTime.utc(2024, 10, 7),
    DateTime.utc(2024, 10, 16),
  ];
  DateTime today = DateTime.now();

  return Column(
    children: [
      Text(
        "Activity",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      Container(
        height: 250,
        width: 350,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TableCalendar(
          rowHeight: 30,
          focusedDay: today,
          firstDay: DateTime.utc(2024, 9, 1),
          lastDay: today,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.green, //Färgen på en dag man tränat
              shape: BoxShape.circle, //formen på det som markerar en tränad dag
            ),
          ),
          selectedDayPredicate: (day) {
            //Anger vilka dagar som ska markeras som valda (träningsdagar) i kalendern.
            return trainingDays.any((trainingDay) => isSameDay(
                day, trainingDay)); //Loopar igenom dagarna i trainingDays
            //och kontrollerar om den aktuella dagen (day)
            //är samma som någon av träningsdagarna (trainingDay).
          },
        ),
      ),
    ],
  );
}
