import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:trainingapp/states/screen_index_provider.dart';
import 'package:trainingapp/components/weather_tile.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';

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
    String userName = context.watch<WorkoutProvider>().userName;
    List trainingDays = context.watch<WorkoutProvider>().trainingDays;
    String totalTrainingDays = trainingDays.length.toString();

    final String currentMonth = getCurrentMonth();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hem", style: TextStyle(fontSize: 45)),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
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
                "Goodmorning $userName",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentMonth,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 45,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Total Workouts: $totalTrainingDays",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(13.0),
              child: CalendarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List trainingDays = context.watch<WorkoutProvider>().trainingDays;

    //Lista med dagar där man tränat
    DateTime today = DateTime.now();

    return Column(
      children: [
        const Text(
          "Activity",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TableCalendar(
            headerStyle: const HeaderStyle(
                formatButtonVisible:
                    false), //Döljer knappen "2 weeks" som kommer som standard
            rowHeight: 40,
            focusedDay: today,
            firstDay: DateTime.utc(2024, 9, 1),
            lastDay: today,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green, //Färgen på en dag man tränat
                shape:
                    BoxShape.circle, //formen på det som markerar en tränad dag
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
}
