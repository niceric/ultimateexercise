import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';

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
