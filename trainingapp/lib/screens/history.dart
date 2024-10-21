import 'package:flutter/material.dart';
import '../components/history_tile.dart';
import 'package:trainingapp/components/bottom_appbar.dart';

class Historypage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Historik'),
      ),
      body: ListView(
        children: [
          HistoryTile(
            date: 'Ons 9',
            workoutName: 'Rygg/Biceps',
            duration: '1h 15min',
            weatherIcon: 'sun',
            temperature: '20°C',
          ),
          HistoryTile(
            date: 'Tis 8',
            workoutName: 'Ben/Mage',
            duration: '1h 16min',
            weatherIcon: 'sun',
            temperature: '15°C',
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
