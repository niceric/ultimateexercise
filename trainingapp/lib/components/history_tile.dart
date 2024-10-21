import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final String date;        
  final String workoutName; 
  final String duration;    
  final String weatherIcon; 
  final String temperature; 

  const HistoryTile({
    Key? key,
    required this.date,
    required this.workoutName,
    required this.duration,    
    required this.weatherIcon,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue[50],  
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date,
                style: TextStyle(fontWeight: FontWeight.bold),  
              ), 
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workoutName,
                style: TextStyle(color: Colors.blueGrey[800], fontSize: 16),  
              ),
              SizedBox(height: 4),
              Text(
                'Duration: $duration',  
                style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny, color: Colors.orange),  
              Text(
                temperature,
                style: TextStyle(color: Colors.blueGrey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
